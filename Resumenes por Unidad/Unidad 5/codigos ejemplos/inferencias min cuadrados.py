import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import norm

fig = plt.figure(figsize=(10, 6))
ax = fig.add_subplot(111, projection="3d")

# Parámetros del modelo
alpha, beta, sigma = 10, 2, 3
x_vals = [5, 10, 15]

# Recta de regresión poblacional en el plano base (z = 0)
x_line = np.linspace(2, 18, 100)
y_line = alpha + beta * x_line
ax.plot(
    x_line,
    y_line,
    zs=0,
    zdir="z",
    color="black",
    linewidth=2,
    label=r"$E[Y|X] = 10 + 2x$",
)

# Campanas de Gauss en cada x_i
for xi in x_vals:
    mu = alpha + beta * xi
    y_range = np.linspace(mu - 4 * sigma, mu + 4 * sigma, 200)
    density = norm.pdf(y_range, loc=mu, scale=sigma)

    # Dibujar la curva normal perpendicular al plano
    ax.plot(
        np.full_like(y_range, xi),
        y_range,
        density,
        color="royalblue",
        linewidth=1.8,
    )
    # Eje central de la media
    ax.plot(
        [xi, xi],
        [mu, mu],
        [0, norm.pdf(mu, mu, sigma)],
        color="gray",
        linestyle="--",
    )

# Puntos muestrales observados
x_sample = [5, 10, 15]
y_sample = [22, 27, 41]
ax.scatter(
    x_sample,
    y_sample,
    zs=0,
    zdir="z",
    color="crimson",
    s=45,
    label="Muestra observada $(x_i, y_i)$",
)

ax.set_xlabel("X (Horas de estudio)")
ax.set_ylabel("Y (Calificación)")
ax.set_zlabel("Densidad f(y|x)")
ax.view_init(elev=25, azim=-60)
ax.legend()
plt.tight_layout()
plt.show()