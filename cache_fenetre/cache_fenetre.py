# Cache pour trou de 143 mm dans une fenetre en plexi (tuyau de clim mobile)
# Une seule piece : une collerette cote interieur + une jupe qui rentre en force dans le trou.
import cadquery as cq, math

TROU        = 143.0   # diametre du trou mesure (14,3 cm)
JEU         = 0.4     # la jupe est un peu plus petite que le trou
NERVURE     = 0.6     # saillie des nervures qui ecrasent pour tenir en force
N_NERVURES  = 36
COLLERETTE  = 173.0   # deborde de 15 mm tout autour
EP_COLL     = 2.4     # epaisseur de la collerette
HAUT_JUPE   = 6.0     # profondeur dans le trou (plexi jusqu'a ~6 mm)
EP_JUPE     = 2.0     # paroi de la jupe
CHANFREIN   = 1.2     # entree en biseau pour faciliter la pose

r_ext = (TROU - JEU) / 2

coll = cq.Workplane("XY").circle(COLLERETTE / 2).extrude(EP_COLL).edges(">Z").fillet(1.0)

# languette pour retirer le cache
lang = (cq.Workplane("XY").center(COLLERETTE / 2 + 6, 0).rect(24, 22).extrude(EP_COLL)
        .edges("|Z").fillet(6)
        .faces(">Z").workplane().center(4, 0).hole(9))

jupe = (cq.Workplane("XY").workplane(offset=EP_COLL)
        .circle(r_ext).circle(r_ext - EP_JUPE).extrude(HAUT_JUPE)
        .faces(">Z").edges("not %LINE").edges(cq.selectors.RadiusNthSelector(1)).chamfer(CHANFREIN))

nerv = None
for i in range(N_NERVURES):
    a = 360 * i / N_NERVURES
    n = (cq.Workplane("XY").workplane(offset=EP_COLL)
         .center(r_ext - 0.3, 0).rect(0.6 + 2 * NERVURE, 2.0).extrude(HAUT_JUPE - CHANFREIN - 0.4)
         .rotate((0, 0, 0), (0, 0, 1), a))
    nerv = n if nerv is None else nerv.union(n)

piece = coll.union(lang).union(jupe).union(nerv)
cq.exporters.export(piece, "cache_fenetre_v2.stl", tolerance=0.02, angularTolerance=0.1)
print("ok")
