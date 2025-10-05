import './style.css';

function renderHTML() {
  if (document.querySelector<HTMLDivElement>('#app') === null) {
  }
  document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
  <div>
    <div class="header">
      <h1>
        Hello World!
      </h1>
    </div>
    <div class="card">
      <p>
        Welcome to my site, thanks for stopping by!
        I'm a DevOps engineer focused on building reliable back-ends.
        You can find my side projects on my <a href="https://github.com/dandeandean">personal Github account</a>.
      </p>
    </div>
  </div>
`
}

renderHTML()
