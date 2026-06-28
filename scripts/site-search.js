// Client-side site search for ToadVille Bay
// Scans a set of known pages, extracts text, finds matches, and renders results.
(function(){
  // Pages to search (relative to site root where search.html lives)
  const PAGES = [
    { url: './index.html', title: 'Home' },
    { url: 'English/en.html', title: 'English – Home' },
    { url: 'English/inm.html', title: 'English – Immigration' },
    { url: 'French/fr.html', title: 'Français – Accueil' },
    { url: 'French/inm.html', title: 'Français – Immigration' },
    { url: 'Spanish/es.html', title: 'Español – Inicio' },
    { url: 'Spanish/inm.html', title: 'Español – Inmigración' },
    { url: 'Legal/privacy.html', title: 'Privacy' },
    { url: 'Legal/termsofservice.html', title: 'Terms of Service' },
    { url: 'Legal/communityguidelines.html', title: 'Community Guidelines' }
  ];

  // Utility to get plain text from HTML
  function htmlToText(html){
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    // Remove script/style
    doc.querySelectorAll('script,style,noscript').forEach(n=>n.remove());
    return doc.body.textContent.replace(/\s+/g,' ').trim();
  }

  function makeSnippet(text, query){
    const q = query.trim();
    if(!q) return '';
    const idx = text.toLowerCase().indexOf(q.toLowerCase());
    if(idx === -1){
      return text.slice(0, 140) + (text.length > 140 ? '…' : '');
    }
    const start = Math.max(0, idx - 60);
    const end = Math.min(text.length, idx + q.length + 80);
    return (start>0?'…':'') + text.slice(start, end) + (end<text.length?'…':'');
  }

  async function searchSite(query){
    const results = [];
    // Run fetches in parallel
    await Promise.all(PAGES.map(async (page)=>{
      try{
        const res = await fetch(page.url, { cache: 'no-store' });
        if(!res.ok) return;
        const html = await res.text();
        const text = htmlToText(html);
        if(text.toLowerCase().includes(query.toLowerCase())){
          results.push({ page, snippet: makeSnippet(text, query) });
        }
      }catch(e){ /* ignore fetch errors (e.g., file protocol restrictions) */ }
    }));
    return results;
  }

  function ensureResultsContainer(){
    let c = document.getElementById('search-results');
    if(!c){
      c = document.createElement('section');
      c.id = 'search-results';
      c.className = 'card-grid';
      c.innerHTML = '<h2>Search results</h2><div class="grid" role="list"></div>';
      // Insert near top of main content if possible
      const main = document.querySelector('main.page-content') || document.body;
      main.prepend(c);
    }
    return c;
  }

  function renderResults(query, items){
    const container = ensureResultsContainer();
    const grid = container.querySelector('.grid');
    grid.innerHTML = '';
    if(!items.length){
      grid.innerHTML = '<div class="card"><h3>No results</h3><p>No matches found for "'+escapeHtml(query)+'".</p></div>';
      return;
    }
    items.forEach(({page, snippet})=>{
      const card = document.createElement('a');
      card.className = 'card';
      card.href = page.url;
      card.innerHTML = '<h3>'+escapeHtml(page.title)+'</h3><p>'+escapeHtml(snippet)+'</p>';
      grid.appendChild(card);
    });
  }

  function escapeHtml(s){
    return (s||'').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[c]));
  }

  // Utility: get URL param
  function getParam(name){
    const p = new URLSearchParams(window.location.search);
    return p.get(name) || '';
  }

  // Decide the search page path relative to the current location
  function resolveSearchPage(){
    const path = window.location.pathname.replace(/\\/g,'/');
    // If we are inside a subfolder like /English/, go up one level
    if(/\/English\//.test(path) || /\/French\//.test(path) || /\/Spanish\//.test(path) || /\/Legal\//.test(path)){
      return '../search.html';
    }
    return './search.html';
  }

  // Global handler used by forms: onsubmit="handleSearch(event)"
  window.handleSearch = function(e){
    e.preventDefault();
    const form = e.target;
    const input = form.querySelector('input[type="search"], input[name="q"], #q');
    const q = (input && input.value ? input.value.trim() : '');
    if(!q){ input && input.focus(); return; }
    const dest = resolveSearchPage();
    window.location.href = dest + '?q=' + encodeURIComponent(q);
  };

  // If we are on search.html, execute a search on load
  document.addEventListener('DOMContentLoaded', async function(){
    const path = window.location.pathname.replace(/\\/g,'/');
    if(!/\/search\.html$/.test(path)) return;
    const q = getParam('q');
    const container = ensureResultsContainer();
    const grid = container.querySelector('.grid');
    if(!q){
      grid.innerHTML = '<div class="card"><p>Type a query into the search box above.</p></div>';
      return;
    }
    grid.innerHTML = '<div class="card"><p>Searching…</p></div>';
    const items = await searchSite(q);
    renderResults(q, items);
  });
})();
