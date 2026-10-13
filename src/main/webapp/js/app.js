/**
 * Digital Voting System — Client-side JS
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
'use strict';

// Auto-dismiss flash messages after 4s
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.flash').forEach(el => {
    setTimeout(() => {
      el.style.transition = 'opacity 0.4s ease';
      el.style.opacity = '0';
      setTimeout(() => el.remove(), 400);
    }, 4000);
  });
});
