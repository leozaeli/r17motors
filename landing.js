const dialog = document.querySelector('#whatsapp-dialog');
const openButton = document.querySelector('.whatsapp-float');
const closeButton = document.querySelector('.dialog-close');
const form = document.querySelector('#whatsapp-form');

openButton?.addEventListener('click', () => dialog?.showModal());
closeButton?.addEventListener('click', () => dialog?.close());
dialog?.addEventListener('click', (event) => {
  if (event.target === dialog) dialog.close();
});

form?.addEventListener('submit', (event) => {
  event.preventDefault();
  const data = new FormData(form);
  const message = [
    'Olá, R17 Motors!',
    '',
    `Nome: ${data.get('name')}`,
    `Telefone: ${data.get('phone')}`,
    `Interesse: ${data.get('interest')}`,
    `Mensagem: ${data.get('message') || 'Não informada.'}`
  ].join('\n');
  window.open(`https://wa.me/5571991954004?text=${encodeURIComponent(message)}`, '_blank', 'noopener');
  dialog.close();
});
