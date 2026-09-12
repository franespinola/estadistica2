import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import norm

# 1. Configuración de parámetros
mu0 = 20.0  # H0: media = 20 (curva roja)
mu1 = 21.0  # H1: media = 21 (curva azul)
sigma_x = 1 / np.sqrt(2 * np.pi)  # ~0.3989 para altura máxima = 1.0
x_crit = 20.67  # Valor crítico

# Rango del eje x
x = np.linspace(18.8, 23.2, 1000)
y0 = norm.pdf(x, mu0, sigma_x)
y1 = norm.pdf(x, mu1, sigma_x)

# 2. Configuración de la figura
fig, ax = plt.subplots(figsize=(9, 5), dpi=300)

# Curvas de densidad
ax.plot(x, y0, color="#e63946", lw=2, zorder=4)
ax.plot(x, y1, color="#1d3557", lw=2, zorder=4)

# Sombreado: Error Tipo II (beta) -> bajo curva azul a la izquierda de x_crit
x_beta = np.linspace(18.8, x_crit, 600)
y_beta = norm.pdf(x_beta, mu1, sigma_x)
ax.fill_between(x_beta, 0, y_beta, color="#f4a261", alpha=0.9, zorder=2)

# Sombreado: Error Tipo I (alfa) -> bajo curva roja a la derecha de x_crit
x_alpha = np.linspace(x_crit, 23.2, 600)
y_alpha = norm.pdf(x_alpha, mu0, sigma_x)
ax.fill_between(x_alpha, 0, y_alpha, color="#b0b0b0", alpha=0.8, zorder=3)

# Línea divisoria del valor crítico
ax.plot([x_crit, x_crit], [0, 0.95], color="black", lw=2, zorder=5)

# 3. Textos y anotaciones superiores
ax.text(20, 1.02, "20", ha="center", va="bottom", fontsize=11)
ax.text(21, 1.02, "21", ha="center", va="bottom", fontsize=11)
ax.text(
    (20 + x_crit) / 2,
    1.12,
    "A",
    ha="center",
    va="bottom",
    fontsize=12,
    fontweight="bold",
)
ax.plot([x_crit, 21.6], [1.13, 1.13], color="black", lw=2)

# Fórmulas de la izquierda
ax.text(
    18.4,
    0.70,
    r"$\mathrm{dnorm}\left(x, \mu, \frac{\sigma}{\sqrt{n}}\right)$",
    fontsize=11,
    ha="right",
)
ax.plot([17.7, 18.2], [0.62, 0.62], color="#e63946", lw=2, clip_on=False)

ax.text(
    18.4,
    0.45,
    r"$\mathrm{dnorm}\left(x, 21, \frac{\sigma}{\sqrt{n}}\right)$",
    fontsize=11,
    ha="right",
)
ax.plot([17.7, 18.2], [0.37, 0.37], color="#1d3557", lw=2, clip_on=False)

# Anotación Error Tipo II (beta)
ax.text(
    19.7,
    1.20,
    "Probabilidad de Aceptar algo\nIncorrecto",
    ha="center",
    va="bottom",
    fontsize=9.5,
)
ax.text(
    19.7,
    1.10,
    "Error tipo II (beta)",
    ha="center",
    va="center",
    fontsize=9.5,
    bbox=dict(boxstyle="ellipse,pad=0.4", fc="white", ec="black", lw=1.3),
)
ax.annotate(
    "",
    xy=(20.45, 0.35),
    xytext=(19.9, 1.03),
    arrowprops=dict(arrowstyle="->", lw=1.5, color="black"),
)

# Anotación Error Tipo I (alfa)
ax.text(
    22.3,
    1.10,
    "Error Tipo I (alfa)",
    ha="center",
    va="center",
    fontsize=9.5,
    bbox=dict(boxstyle="ellipse,pad=0.4", fc="white", ec="black", lw=1.3),
)
ax.text(
    22.3,
    0.95,
    "Probabilidad de\nRechazar algo\ncorrecto",
    ha="center",
    va="top",
    fontsize=9.5,
)
ax.annotate(
    "",
    xy=(20.85, 0.08),
    xytext=(22.0, 0.78),
    arrowprops=dict(arrowstyle="->", lw=1.5, color="black"),
)

# 4. Configuración de ejes y límites
ax.set_xlim(19.0, 23.0)
ax.set_ylim(0, 1.25)
ax.set_xticks([19, 20, 21, 22, 23])
ax.set_yticks([0.2, 0.4, 0.6, 0.8, 1.0])
ax.set_xlabel("x", fontsize=11, labelpad=8)
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

plt.tight_layout()
plt.savefig("grafico_alta_resolucion.png", dpi=300)
plt.savefig("grafico_vectorial.pdf")  # Para inclusión en LaTeX/Word
plt.show()