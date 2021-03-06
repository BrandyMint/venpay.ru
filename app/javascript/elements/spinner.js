// goga https://github.com/dapi/elements/blob/master/spinner.js
// More spinners - https://tobiasahlin.com/spinkit/

// Usage example:
//
// <dapi-spinner></dapi-spinner>
//
// More examples - https://dapi.github.io/elements/
//
let tmpl = document.createElement('template');
tmpl.innerHTML = `
<style>
:host {
  margin: auto;
  display: block;
  width: 50px;
  height: 50px;
  border: 3px solid rgba(0,0,0,.3);
  border-radius: 50%;
  border-top-color: #fff;
  animation: dapi-spin 1s ease-in-out infinite;
}

:host([inline]) {
  margin: 0;
  display: inline-block;
  height: 12px;
  width: 12px;
}

:host([page]) {
  margin: 50% auto;
}

@keyframes dapi-spin {
  to { transform: rotate(360deg); }
}
</style>`;

customElements.define('dapi-spinner', class extends HTMLElement {
   constructor() {
    super(); // always call super() first in the constructor.

    // Attach a shadow root to the element.
    let shadowRoot = this.attachShadow({mode: 'open'});
    shadowRoot.appendChild(tmpl.content.cloneNode(true));
  }
} )
