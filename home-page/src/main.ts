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
        Welcom to my site, thanks for stopping by!
        I'm a DevOps engineer focused on building powerful back-ends.
        I'm also passionate about side projects, so you'll see a mix of professional work and personal experiments here.
      </p>
    </div>
  </div>
`
}

renderHTML()
