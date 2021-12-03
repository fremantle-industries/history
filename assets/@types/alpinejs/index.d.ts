declare global {
  interface Window {
    Alpine: any;
  }

  interface HTMLElement {
    _x_dataStack: any
  }
}

export {}
