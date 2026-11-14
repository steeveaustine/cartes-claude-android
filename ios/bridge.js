// Injecté par l'appli iPhone avant le chargement de la page.
(function () {
  function post(name, value) {
    try { window.webkit.messageHandlers[name].postMessage(String(value)); } catch (e) {}
  }

  // Copier : la page appelle Android.copy(texte) quand ce pont existe.
  window.Android = { copy: function (text) { post("copy", text); } };

  // Liens externes : Safari, ou l'appli concernée (Claude, Mail, Téléphone…).
  var external = /^(https?|mailto|tel|sms):/i;
  document.addEventListener("click", function (e) {
    var a = e.target && e.target.closest ? e.target.closest("a[href]") : null;
    if (!a || !external.test(a.href)) return;
    e.preventDefault();
    post("open", a.href);
  }, true);
  window.open = function (u) {
    if (u) post("open", new URL(u, location.href).href);
    return null;
  };

  // Bande sous la barre d'état, de la couleur du fond de page, clair ou sombre.
  var css = ":root{padding-top:env(safe-area-inset-top,0px)}" +
    "#ios-top{position:fixed;left:0;right:0;top:0;height:env(safe-area-inset-top,0px);" +
    "background:var(--bg);z-index:50;pointer-events:none}";
  document.addEventListener("DOMContentLoaded", function () {
    var s = document.createElement("style");
    s.textContent = css;
    document.head.appendChild(s);
    var d = document.createElement("div");
    d.id = "ios-top";
    document.body.appendChild(d);
  });
})();
