import numpy as np


import os

print("Estou rodando em:", os.getcwd())
print("Arquivos nessa pasta:", os.listdir(os.getcwd()))


base = os.path.dirname(__file__)   # pega a pasta do script
mif_path = os.path.join(base, "gatinho1_convertido.mif")




def read_mif(filename):
    data = []
    in_content = False
    with open(filename, "r") as f:
        for line in f:
            line = line.strip().lower()
            if line.startswith("content"):
                in_content = True
                continue
            if not in_content:
                continue
            if line.startswith("end;"):
                break
            if ":" in line:
                _, val = line.split(":")
                val = val.replace(";", "").strip()
                # pega apenas os últimos 2 dígitos hex (1 byte)
                data.append(int(val[-2:], 16))
    return np.array(data, dtype=np.uint8)


# Lê o MIF (160x120 = 19200 pixels)
pixels = read_mif(mif_path)

img = pixels.reshape((120, 160))  # altura x largura

# Amostragem em blocos 20x20 (gera 6x8 = 48 blocos)
features = []
for by in range(0, 120, 20):
    for bx in range(0, 160, 20):
        block = img[by:by+20, bx:bx+20]
        mean_val = block.mean()   # média dos pixels no bloco
        features.append(mean_val)

features = np.array(features, dtype=np.uint8)

# Compactação → threshold em 128
binary_features = (features > 128).astype(np.uint8)

# Vetor final de 48 bits
bitstring = "".join(str(b) for b in binary_features)
vec_48 = int(bitstring, 2)



# Salvar em .dat
with open("gatinho_reduzido.dat", "w") as f:
    f.write(f"{vec_48:012x}\n")   # 48 bits = 12 hex chars

# Salvar em .mif
with open("gatinho_reduzido.mif", "w") as f:
    f.write("DEPTH = 1;\n")
    f.write("WIDTH = 48;\n")
    f.write("ADDRESS_RADIX = HEX;\n")
    f.write("DATA_RADIX = HEX;\n")
    f.write("CONTENT BEGIN\n")
    f.write(f"0 : {vec_48:012x};\n")
    f.write("END;\n")


print("Médias dos primeiros blocos:", features[:10])
print("Binário dos primeiros blocos:", binary_features[:10])
print("Vetor 48 bits (decimal):", vec_48)
print("Vetor 48 bits (binário):", bitstring)