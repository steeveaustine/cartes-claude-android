# Anneau d'essai : seulement le bord de la jupe (143 mm), pour tester l'ajustement avant le cache complet
import cadquery as cq
TROU, JEU, NERVURE, N = 143.0, 0.4, 0.6, 36
r = (TROU - JEU) / 2
base = cq.Workplane("XY").circle(r + 4).circle(r - 2).extrude(1.2)
jupe = cq.Workplane("XY").workplane(offset=1.2).circle(r).circle(r - 2).extrude(8)
p = base.union(jupe)
for i in range(N):
    p = p.union(cq.Workplane("XY").workplane(offset=1.2).center(r - 0.3, 0)
                .rect(0.6 + 2 * NERVURE, 2).extrude(6.4).rotate((0, 0, 0), (0, 0, 1), 360 * i / N))
cq.exporters.export(p, "anneau_essai_143.stl", tolerance=0.02, angularTolerance=0.1)
