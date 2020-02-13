
class MachineStatus extends HTMLElement {
  connectedCallback() {
    this.refresh()
  }

  refresh = () => {
    const onLoad = (response) => {
      this
      .querySelector('[data-refresh]')
      .addEventListener('click', this.refresh )
    }
    $(this).load(this.dataset.url, onLoad)
  }
}

customElements.define('dapi-machine-status', MachineStatus, {extends: 'div'});