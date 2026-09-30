import os
import sys
from openai import OpenAI

# Inicializar el cliente con la clave de NVIDIA NIM
client = OpenAI(
    base_url="https://integrate.api.nvidia.com/v1",
    api_key="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"
)

prompt = "¿Puedes presentarte brevemente y decir en qué te diferencias de otros modelos?"

print(f"Enviando consulta a nvidia/nemotron-3-ultra-550b-a55b...")

try:
    completion = client.chat.completions.create(
        model="nvidia/nemotron-3-ultra-550b-a55b",
        messages=[
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        top_p=0.95,
        max_tokens=1024,
        extra_body={"chat_template_kwargs": {"enable_thinking": True}}
    )

    print("\n--- RESPUESTA DE NEMOTRON 3 ULTRA ---")
    print(completion.choices[0].message.content)
    print("-------------------------------------")

except Exception as e:
    print(f"Error al llamar a la API: {e}", file=sys.stderr)
