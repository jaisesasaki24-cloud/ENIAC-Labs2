import {
  AngularNodeAppEngine,
  createNodeRequestHandler,
  isMainModule,
  writeResponseToNodeResponse,
} from '@angular/ssr/node';
import express from 'express';
import {join} from 'node:path';
import {exec} from 'node:child_process';

const browserDistFolder = join(import.meta.dirname, '../browser');

const app = express();
app.set('trust proxy', true);
app.use(express.json());

process.env['NG_ALLOWED_HOSTS'] = '*';

const angularApp = new AngularNodeAppEngine({
  allowedHosts: ['*'],
});

const TARGET_MAP: Record<string, string> = {
  grafana: 'http://localhost:3000',
  kafka: 'http://localhost:18085',
  eureka: 'http://localhost:18761',
  keycloak: 'http://localhost:18180/admin/eniaclabs/console/',
  frontend: 'https://localhost:4200/catalogo',
  catalogo: 'https://localhost:4200/catalogo',
  pedidos: 'https://localhost:4200/mis-pedidos',
  'mis-pedidos': 'https://localhost:4200/mis-pedidos',
  pagar: 'https://localhost:4200/pagar',
  checkout: 'https://localhost:4200/pagar',
  mkdocs: 'http://localhost:8000',
  c4: 'http://localhost:8000',
  prometheus: 'http://localhost:9090',
  config: 'http://localhost:18888/pc-pago-ms/prod',
  launcher: 'https://localhost:4200/launcher.html',
};

// Endpoint de control remoto de la pantalla de la PC
app.all(['/remote/open', '/open'], (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }

  const target = (req.query['target'] || req.body?.target) as string;
  const urlParam = (req.query['url'] || req.body?.url) as string;
  const destination = urlParam || (target ? TARGET_MAP[target.toLowerCase()] : null);

  if (destination) {
    console.log(`[PC REMOTE] Abriendo en navegador de la PC: ${destination}`);
    exec(`start "" "${destination}"`, (err) => {
      if (err) {
        console.error('[PC REMOTE] Error al ejecutar comando start:', err);
      }
    });
    return res.json({
      success: true,
      target,
      opened_url: destination,
      message: `Ventana abierta exitosamente en la PC: ${destination}`,
    });
  }

  return res.status(400).json({error: 'Target o URL no especificado'});
});

app.get(['/remote/status', '/status'], (_req, res) => {
  res.json({status: 'UP', service: 'PC Remote Controller (Angular Express)'});
});

/**
 * Serve static files from public/ directly
 */
const publicFolder = join(process.cwd(), 'public');
app.use(express.static(publicFolder));

/**
 * Serve static files from /browser
 */
app.use(
  express.static(browserDistFolder, {
    maxAge: '1y',
    index: false,
    redirect: false,
  }),
);

/**
 * Handle all other requests by rendering the Angular application.
 */
app.use((req, res, next) => {
  angularApp
    .handle(req)
    .then((response) =>
      response ? writeResponseToNodeResponse(response, res) : next(),
    )
    .catch(next);
});

/**
 * Start the server if this module is the main entry point, or it is ran via PM2.
 * The server listens on the port defined by the `PORT` environment variable, or defaults to 4000.
 */
if (isMainModule(import.meta.url) || process.env['pm_id']) {
  const port = process.env['PORT'] || 4000;
  app.listen(port, (error) => {
    if (error) {
      throw error;
    }

    console.log(`Node Express server listening on http://localhost:${port}`);
  });
}

/**
 * Request handler used by the Angular CLI (for dev-server and during build) or Firebase Cloud Functions.
 */
export const reqHandler = createNodeRequestHandler(app);
