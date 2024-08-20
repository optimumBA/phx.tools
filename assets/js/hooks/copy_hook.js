export default {
  mounted() {
    const copySvg = `
    <svg width="18" height="20" viewBox="0 0 18 20" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M5 3H3C1.89543 3 1 3.89543 1 5V17C1 18.1046 1.89543 19 3 19H13C14.1046 19 15 18.1046 15 17V16M5 3C5 4.10457 5.89543 5 7 5H9C10.1046 5 11 4.10457 11 3M5 3C5 1.89543 5.89543 1 7 1H9C10.1046 1 11 1.89543 11 3M11 3H13C14.1046 3 15 3.89543 15 5V8M17 12H7M7 12L10 9M7 12L10 15"
        stroke="white"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    `
    const copiedSvg = `
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-circle-check" width="44" height="24" viewBox="0 0 24 24" stroke-width="1.5" stroke="white" fill="none"    stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <path d="M12 12m-9 0a9 9 0 1 0 18 0a9 9 0 1 0 -18 0" />
        <path d="M9 12l2 2l4 -4" />
      </svg>
    `

    this.el.addEventListener('click', () => {
      var copyText = document.getElementById('tool-installation').innerText
      navigator.clipboard.writeText(copyText)
      copyBtn = document.getElementById('copy')
      copyBtn.innerHTML = copiedSvg
      copyBtn.setAttribute('disabled', '')

      setTimeout(() => {
        copyBtn.innerHTML = copySvg
        copyBtn.removeAttribute('disabled')
        copyBtn.classList.remove('bg-[#9887FF]')
      }, 1000)
    })
  },
}
