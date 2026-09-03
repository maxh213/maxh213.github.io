import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  case build_site() {
    Ok(_) -> {
      io.println("✨ Site built successfully!")
      io.println("📁 Files written to: dist/")
    }
    Error(error) -> {
      io.println("❌ Error building site:")
      io.println(string.inspect(error))
      Nil
    }
  }
}

fn build_site() -> Result(Nil, simplifile.FileError) {
  use _ <- result.try(simplifile.create_directory_all("dist"))
  use _ <- result.try(write_index_page())
  use _ <- result.try(write_css())
  write_javascript()
}

fn write_index_page() -> Result(Nil, simplifile.FileError) {
  use content <- result.try(simplifile.read("content/index.djot"))
  let config = parse_config(content)
  let html = wrap_with_template(config, "Max Harris — Software Engineer")
  simplifile.write(html, to: "dist/index.html")
}

fn parse_config(content: String) -> List(#(String, String)) {
  content
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    case string.split_once(line, ": ") {
      Ok(#(key, value)) -> Ok(#(string.trim(key), string.trim(value)))
      Error(_) -> Error(Nil)
    }
  })
}

fn get_config_value(config: List(#(String, String)), key: String) -> String {
  config
  |> list.find(fn(item) { item.0 == key })
  |> result.map(fn(item) { item.1 })
  |> result.unwrap("")
}

fn display_url(url: String) -> String {
  let step1 = string.replace(url, "https://www.", "")
  let step2 = string.replace(step1, "https://", "")
  let step3 = string.replace(step2, "http://www.", "")
  string.replace(step3, "http://", "")
}

fn wrap_with_template(config: List(#(String, String)), title: String) -> String {
  let name = get_config_value(config, "name")
  let job_title = get_config_value(config, "title")
  let about = get_config_value(config, "about")
  let linkedin_url = get_config_value(config, "linkedin_url")
  let github_url = get_config_value(config, "github_url")
  let email = get_config_value(config, "email")
  let phone = get_config_value(config, "phone")
  let linkedin_handle = display_url(linkedin_url)
  let github_handle = display_url(github_url)

  "<!DOCTYPE html>
<html lang='en' data-theme='light'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>" <> title <> "</title>
    <meta name='description' content='" <> name <> " - " <> job_title <> " — " <> about <> "'>
    <meta name='author' content='" <> name <> "'>
    <meta name='theme-color' content='#fdfbf7' id='theme-color'>
    <meta property='og:title' content='" <> title <> "'>
    <meta property='og:description' content='" <> about <> "'>
    <meta property='og:type' content='website'>
    <meta property='og:url' content='https://maxh213.github.io/'>
    <meta name='twitter:card' content='summary'>
    <link rel='canonical' href='https://maxh213.github.io/'>
    <link rel='icon' href='data:image/svg+xml,<svg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22><text%20y=%22.9em%22%20font-size=%2290%22>👋</text></svg>'>
    <link rel='preconnect' href='https://fonts.googleapis.com'>
    <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>
    <link href='https://fonts.googleapis.com/css2?family=Kalam:wght@700&family=Patrick+Hand&display=swap' rel='stylesheet'>
    <link rel='stylesheet' href='style.css'>
    <script>
(function(){var d=document.documentElement;d.classList.add('js');var t=null;try{t=localStorage.getItem('theme');}catch(e){t=null;}if(!t){try{t=window.matchMedia&&window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light';}catch(e2){t='light';}}t=t||'light';d.setAttribute('data-theme',t);var m=document.getElementById('theme-color');if(m){m.setAttribute('content',t==='dark'?'#1f1d19':'#fdfbf7');}})();
    </script>
    <script src='main.js' defer></script>
    <script type='application/ld+json'>{\"@context\":\"https://schema.org\",\"@type\":\"Person\",\"name\":\"" <> name <> "\",\"jobTitle\":\"" <> job_title <> "\",\"url\":\"https://maxh213.github.io/\",\"sameAs\":[\"" <> linkedin_url <> "\",\"" <> github_url <> "\"],\"email\":\"mailto:" <> email <> "\"}</script>
</head>
<body>
    <a class='skip-link' href='#main'>Skip to content</a>

    <nav class='nav' aria-label='Primary'>
        <div class='container nav-inner'>
            <a href='#top' class='logo' aria-label='Home'>MH<span class='logo-dot'>•</span><span class='logo-sub'>scribbles &amp; code</span></a>
            <div class='nav-links'>
                <a href='#about' class='nav-link' id='nav-about'>About</a>
                <a href='#contact' class='nav-link' id='nav-contact'>Contact</a>
                <button class='theme-toggle' id='theme-toggle' type='button' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;' aria-label='Switch to dark mode' aria-pressed='false' title='Switch to dark mode'>
                    <span class='icon-moon' aria-hidden='true'>☾</span>
                    <span class='icon-sun' aria-hidden='true'>☀</span>
                </button>
                <a href='" <> github_url <> "' target='_blank' rel='noopener noreferrer' class='btn btn-nav' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;' aria-label='GitHub profile (opens in a new tab)'>GitHub →</a>
            </div>
        </div>
    </nav>

    <main class='container' id='main'>
        <header class='hero' id='top'>
            <div class='hero-left'>
                <div class='eyebrow fade' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>✦ open to thoughtful collaborations</div>
                <h1 class='hero-title reveal'>
                    <span class='title-scribble' aria-hidden='true'></span>
                    " <> name <> "<span class='bang' aria-hidden='true'>!</span>
                </h1>
                <div class='role-wrap reveal'>
                    <p class='role'>" <> job_title <> "</p>
                    <svg class='wavy' viewBox='0 0 260 12' preserveAspectRatio='none' aria-hidden='true'><path d='M2 8 Q 18 2, 36 8 T 72 8 T 108 8 T 144 8 T 180 8 T 216 8 T 252 8' fill='none' stroke='#ff4d4d' stroke-width='3.2' stroke-linecap='round'/></svg>
                </div>
                <p class='hero-copy reveal'>Building advocacy tech at <strong>Anima International</strong> — lobbying for better chicken welfare, sketching systems on napkins, and shipping with Gleam &amp; curiosity.</p>
                <div class='ctas reveal'>
                    <a href='mailto:" <> email <> "' class='btn btn-primary' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>Say hello ✉️</a>
                    <a href='" <> github_url <> "' target='_blank' rel='noopener noreferrer' class='btn btn-ghost' style='border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;' aria-label='View GitHub profile (opens in a new tab)'>See GitHub</a>
                    <svg class='cta-arrow' viewBox='0 0 120 44' fill='none' aria-hidden='true'><path d='M4 24 Q 38 4, 72 18 T 106 22' stroke='currentColor' stroke-width='2.4' stroke-dasharray='6 4' stroke-linecap='round'/><path d='M99 12 L106 22 L95 30' stroke='currentColor' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round' fill='none'/></svg>
                </div>
                <div class='hero-meta reveal'>
                    <span class='meta-pill' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>Gleam on Erlang</span>
                    <span class='meta-pill muted' style='border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;'>London · Remote</span>
                    <span class='meta-pill yellow' style='border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;'>🐔 for the chickens</span>
                </div>
            </div>
            <div class='hero-right reveal'>
                <div class='stack'>
                    <div class='polaroid back' style='border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;' aria-hidden='true'>
                        <div class='polaroid-top'></div>
                        <div class='polaroid-lines'><span></span><span></span><span></span></div>
                    </div>
                    <div class='polaroid front' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>
                        <div class='tape tape-top' aria-hidden='true'></div>
                        <div class='corner tl'></div><div class='corner tr'></div><div class='corner bl'></div><div class='corner br'></div>
                        <div class='polaroid-inner'>
                            <div class='initials' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>MH</div>
                            <p class='polaroid-caption'>software engineer<br><em>Anima International</em></p>
                            <div class='sticker' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>✎ drawn with care</div>
                        </div>
                    </div>
                    <div class='dot' aria-hidden='true'></div>
                    <div class='ring' aria-hidden='true'></div>
                    <div class='star s1' aria-hidden='true'>✦</div>
                    <div class='star s2' aria-hidden='true'>✦</div>
                </div>
            </div>
        </header>

        <div class='divider' aria-hidden='true'><span class='dash'></span><span class='spark'>✦</span><span class='dash'></span></div>

        <section id='about' class='section' aria-labelledby='about-heading'>
            <div class='label fade' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>01 — about</div>
            <div class='paper fade' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>
                <div class='pin' aria-hidden='true'></div>
                <div class='paper-tag' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>note #01</div>
                <div class='paper-rule' aria-hidden='true'></div>
                <h2 id='about-heading'><span class='drop'>A</span>bout</h2>
                <p class='paper-text'>" <> about <> "</p>
                <p class='paper-foot'>I like small, well-made tools — Gleam, Erlang, and a lot of hand-drawn diagrams. This site is intentionally over-engineered as a way to learn.</p>
                <div class='paper-tags'>
                    <span class='ptag' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>advocacy tech</span>
                    <span class='ptag alt' style='border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;'>systems thinking</span>
                    <span class='ptag yellow' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>welfare first</span>
                </div>
            </div>
        </section>

        <section id='contact' class='section' aria-labelledby='contact-heading'>
            <div class='section-head reveal'>
                <h2 class='section-title' id='contact-heading'>Get in touch</h2>
                <p class='section-sub'>Pin a note — I read them all, promise.</p>
            </div>
            <svg class='squiggle' viewBox='0 0 800 28' fill='none' aria-hidden='true'><path d='M0 14 Q 80 0, 160 14 T 320 14 T 480 14 T 640 14 T 800 14' stroke='currentColor' stroke-width='2' stroke-dasharray='8 6' stroke-linecap='round' opacity='0.22'/></svg>
            <div class='grid'>
                <a href='" <> linkedin_url <> "' target='_blank' rel='noopener noreferrer' class='card c1 fade' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;' aria-label='LinkedIn profile (opens in a new tab)'>
                    <div class='card-tape' aria-hidden='true'></div>
                    <div class='icon' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>💼</div>
                    <h3>LinkedIn</h3>
                    <p class='small'>" <> linkedin_handle <> "</p>
                    <span class='arrow' aria-hidden='true'>↗</span>
                </a>
                <a href='" <> github_url <> "' target='_blank' rel='noopener noreferrer' class='card c2 postit-card fade' style='border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;' aria-label='GitHub profile (opens in a new tab)'>
                    <div class='icon' style='border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;'>💻</div>
                    <h3>GitHub</h3>
                    <p class='small'>" <> github_handle <> "</p>
                    <span class='arrow' aria-hidden='true'>↗</span>
                </a>
                <a href='mailto:" <> email <> "' class='card c3 fade' style='border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;' aria-label='Send an email to " <> email <> "'>
                    <div class='icon' style='border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;'>✉️</div>
                    <h3>Email</h3>
                    <p class='small'>" <> email <> "</p>
                    <span class='arrow' aria-hidden='true'>→</span>
                </a>
                <a href='tel:" <> phone <> "' class='card c4 fade' style='border-radius: 15px 255px 15px 225px / 225px 15px 255px 15px;' aria-label='Call " <> phone <> "'>
                    <div class='card-tape' aria-hidden='true'></div>
                    <div class='icon' style='border-radius: 15px 255px 15px 225px / 225px 15px 255px 15px;'>📱</div>
                    <h3>Phone</h3>
                    <p class='small'>" <> phone <> "</p>
                    <span class='arrow' aria-hidden='true'>→</span>
                </a>
            </div>
        </section>

        <div class='quote-wrap fade'>
            <div class='quote' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>
                <p>“Built needlessly complicated with Gleam — exactly how I like to learn.”</p>
                <span>— the original README</span>
            </div>
        </div>
    </main>

    <footer class='footer'>
        <div class='container footer-inner'>
            <div>
                <h4 class='footer-title'>Max Harris<span class='u' aria-hidden='true'></span></h4>
                <p>Software Engineer · Anima International<br>Sketching better futures for animals, one system at a time.</p>
            </div>
            <div class='footer-links'>
                <a href='" <> linkedin_url <> "' target='_blank' rel='noopener noreferrer'>LinkedIn</a>
                <a href='" <> github_url <> "' target='_blank' rel='noopener noreferrer'>GitHub</a>
                <a href='mailto:" <> email <> "'>Email</a>
            </div>
        </div>
        <div class='container footer-bottom'>
            <span>© <span id='year'></span> — drawn by hand, shipped with Gleam ✎</span>
            <span aria-hidden='true'>〰〰〰</span>
        </div>
    </footer>

    <button class='back-to-top' id='back-to-top' type='button' aria-label='Back to top' style='border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;'>
        <svg viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='2.6' stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'><path d='M12 19V5M5 12l7-7 7 7'/></svg>
    </button>
</body>
</html>"
}

fn write_css() -> Result(Nil, simplifile.FileError) {
  let css =
    ":root{--bg:#fdfbf7;--fg:#2d2d2d;--muted:#e5e0d8;--accent:#ff4d4d;--blue:#2d5da1;--postit:#fff9c4;--line:#f1ede8;--surface:#ffffff;color-scheme:light}
[data-theme='dark']{--bg:#1f1d19;--fg:#e8e3d9;--muted:#38352e;--accent:#ff6b5e;--blue:#8fb8f2;--postit:#403a1e;--line:#2c2923;--surface:#2b2822;color-scheme:dark}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-padding-top:84px}
body{font-family:'Patrick Hand',cursive;background-color:var(--bg);background-image:radial-gradient(var(--muted) 1px, transparent 1px);background-size:24px 24px;color:var(--fg);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased}
h1,h2,h3,h4{font-family:'Kalam',cursive;font-weight:700;line-height:1.05}
a{color:inherit}
::selection{background:var(--postit)}
:focus-visible{outline:3px solid var(--accent);outline-offset:2px}
.container{max-width:1120px;margin:0 auto;padding:0 24px}

.skip-link{position:fixed;top:-80px;left:16px;z-index:100;background:var(--fg);color:var(--bg);border:2px solid var(--fg);border-radius:255px 15px 225px 15px / 15px 225px 15px 255px;padding:10px 18px;text-decoration:none;font-size:1.05rem;font-weight:600;box-shadow:3px 3px 0 rgba(0,0,0,0.25);transition:top 0.2s ease}
.skip-link:focus{top:14px}

.nav{position:sticky;top:0;z-index:30;background:rgba(253,251,247,0.88);backdrop-filter:blur(8px);border-bottom:2.5px solid var(--fg);padding:12px 0 13px}
[data-theme='dark'] .nav{background:rgba(31,29,25,0.88)}
.nav-inner{display:flex;justify-content:space-between;align-items:center;gap:16px;flex-wrap:wrap}
.logo{font-family:'Kalam',cursive;font-weight:700;font-size:1.4rem;text-decoration:none;display:flex;align-items:baseline;gap:6px}
.logo-dot{color:var(--accent);font-size:1.9rem;line-height:0.8}
.logo-sub{font-family:'Patrick Hand',cursive;font-weight:400;font-size:0.98rem;opacity:0.65;margin-left:2px}
.nav-links{display:flex;gap:14px;align-items:center;flex-wrap:wrap}
.nav-link{font-size:1.08rem;text-decoration:none;position:relative;padding:2px 2px 4px}
.nav-link::after{content:'';position:absolute;left:0;right:0;bottom:-6px;height:7px;background:url(\"data:image/svg+xml,%3Csvg width='60' height='7' viewBox='0 0 60 7' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 5 Q 10 1, 20 5 T 40 5 T 60 5' stroke='%23ff4d4d' stroke-width='1.7' fill='none' stroke-linecap='round'/%3E%3C/svg%3E\") repeat-x;opacity:0;transform:translateY(3px);transition:0.14s}
.nav-link:hover::after,.nav-link.is-active::after{opacity:1;transform:translateY(0)}
.theme-toggle{display:inline-flex;align-items:center;justify-content:center;width:44px;height:44px;padding:0;border:2.5px solid var(--fg);background:var(--surface);color:var(--fg);font-size:1.1rem;line-height:1;cursor:pointer;box-shadow:3px 3px 0 0 var(--fg);transform:rotate(0.6deg);transition:transform 0.12s ease, box-shadow 0.12s ease, background 0.12s ease}
.theme-toggle:hover{background:var(--postit);transform:rotate(0deg) translate(2px,2px);box-shadow:1px 1px 0 0 var(--fg)}
.theme-toggle:active{transform:translate(3px,3px);box-shadow:none}
.theme-toggle .icon-sun{display:none}
[data-theme='dark'] .theme-toggle .icon-sun{display:block}
[data-theme='dark'] .theme-toggle .icon-moon{display:none}
.btn{display:inline-flex;align-items:center;justify-content:center;min-height:48px;padding:10px 22px;border:3px solid var(--fg);font-family:'Patrick Hand',cursive;font-size:1.12rem;text-decoration:none;cursor:pointer;transition:transform 0.12s ease, box-shadow 0.12s ease, background 0.12s ease, color 0.12s ease;box-shadow:4px 4px 0 0 var(--fg);background:var(--surface);color:var(--fg);transform:rotate(-0.25deg)}
.btn:hover{background:var(--accent);color:#fff;box-shadow:2px 2px 0 0 var(--fg);transform:translate(2px,2px) rotate(0deg)}
.btn:active{box-shadow:none;transform:translate(4px,4px)}
.btn-nav{min-height:40px;padding:7px 16px;font-size:1rem;box-shadow:3px 3px 0 0 var(--fg);background:var(--fg);color:var(--bg);border-color:var(--fg)}
.btn-nav:hover{background:var(--accent);border-color:var(--fg);box-shadow:2px 2px 0 0 var(--fg)}
.btn-ghost{background:var(--muted)}
.btn-ghost:hover{background:var(--blue)}
.btn-primary{background:var(--surface)}

.hero{display:grid;grid-template-columns:1.15fr 0.85fr;gap:36px;align-items:center;padding:54px 0 10px;scroll-margin-top:84px}
.eyebrow{display:inline-block;background:var(--postit);border:2px solid var(--fg);padding:6px 14px;transform:rotate(-1.1deg);font-size:0.96rem;box-shadow:2px 2px 0 rgba(45,45,45,0.12);margin-bottom:16px}
.hero-title{position:relative;font-size:clamp(3.4rem, 7.2vw, 5.6rem);letter-spacing:-0.03em;z-index:1}
.title-scribble{position:absolute;left:-10px;right:18%;top:8%;bottom:6%;border:2.5px dashed rgba(45,45,45,0.18);transform:rotate(-1.2deg);border-radius:255px 15px 225px 15px / 15px 225px 15px 255px;z-index:-1}
.bang{display:inline-block;color:var(--accent);transform:rotate(12deg) translateY(-6px);margin-left:4px;animation:wiggle 2.6s ease-in-out infinite}
.role-wrap{position:relative;display:inline-block;margin-top:6px}
.role{font-family:'Kalam',cursive;font-size:clamp(1.35rem,3vw,1.85rem);color:var(--blue)}
.wavy{position:absolute;left:-6px;right:-10px;bottom:-10px;width:108%;height:11px}
.hero-copy{font-size:1.22rem;max-width:52ch;margin-top:18px;opacity:0.88}
.ctas{display:flex;gap:12px;margin-top:22px;flex-wrap:wrap;align-items:center;position:relative}
.cta-arrow{position:absolute;left:268px;top:-14px;width:116px;height:42px;transform:rotate(-1deg);opacity:0.95;color:var(--fg)}
.hero-meta{display:flex;gap:8px;flex-wrap:wrap;margin-top:18px}
.meta-pill{border:2px solid var(--fg);padding:5px 10px;background:var(--surface);font-size:0.92rem;box-shadow:2px 2px 0 rgba(45,45,45,0.08);transform:rotate(0.35deg)}
.meta-pill.muted{background:var(--muted);transform:rotate(-0.4deg)}
.meta-pill.yellow{background:var(--postit);transform:rotate(0.7deg)}

.hero-right{display:flex;justify-content:center;align-items:center}
.stack{position:relative;width:100%;max-width:380px;height:420px}
.polaroid{position:absolute;inset:0;background:var(--surface);border:2px solid var(--fg);box-shadow:4px 4px 0 0 var(--fg);padding:18px}
.polaroid.back{transform:rotate(-3.2deg) translate(8px,10px);background:var(--line);display:flex;flex-direction:column;justify-content:space-between;padding:22px 18px}
.polaroid-top{height:42%;border:2px dashed rgba(45,45,45,0.18);background:repeating-linear-gradient( -8deg, transparent 0 10px, rgba(45,45,45,0.04) 10px 11px);border-radius:255px 15px 225px 15px / 15px 225px 15px 255px}
.polaroid-lines{display:flex;flex-direction:column;gap:10px;padding:10px 6px}
.polaroid-lines span{height:8px;background:var(--muted);border-radius:4px;display:block}
.polaroid-lines span:nth-child(1){width:92%}
.polaroid-lines span:nth-child(2){width:78%}
.polaroid-lines span:nth-child(3){width:66%}
.polaroid.front{transform:rotate(1.2deg);display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding-top:30px}
.tape-top{position:absolute;top:-13px;left:50%;width:118px;height:22px;background:rgba(45,45,45,0.08);border:1px solid rgba(45,45,45,0.14);transform:translateX(-50%) rotate(-1.6deg)}
.corner{position:absolute;width:18px;height:18px;border-color:var(--fg);border-style:solid}
.corner.tl{top:10px;left:10px;border-width:3px 0 0 3px}
.corner.tr{top:10px;right:10px;border-width:3px 3px 0 0}
.corner.bl{bottom:10px;left:10px;border-width:0 0 3px 3px}
.corner.br{bottom:10px;right:10px;border-width:0 3px 3px 0}
.polaroid-inner{display:flex;flex-direction:column;align-items:center;gap:12px}
.initials{width:126px;height:126px;display:grid;place-items:center;font-family:'Kalam',cursive;font-weight:700;font-size:4.1rem;background:var(--bg);border:3px solid var(--fg);transform:rotate(-1deg);box-shadow:2px 2px 0 rgba(45,45,45,0.08)}
.polaroid-caption{font-size:1.1rem;line-height:1.25}
.polaroid-caption em{color:var(--blue);font-style:normal}
.sticker{border:2px dashed var(--fg);padding:6px 12px;background:var(--postit);transform:rotate(-0.7deg);font-size:0.96rem}
.dot{position:absolute;top:-8px;right:14px;width:18px;height:18px;background:var(--accent);border:2px solid var(--fg);border-radius:50%;box-shadow:2px 2px 0 var(--fg);animation:float 3s ease-in-out infinite}
.ring{position:absolute;bottom:-12px;left:-10px;width:58px;height:58px;border:2px dashed rgba(45,45,45,0.22);border-radius:50%;transform:rotate(-10deg)}
.star{position:absolute;font-size:1.1rem;color:var(--fg);opacity:0.9}
.star.s1{top:18px;left:-10px;transform:rotate(-8deg)}
.star.s2{bottom:42px;right:-6px;transform:rotate(12deg);color:var(--accent)}

.divider{display:flex;align-items:center;gap:14px;padding:28px 0 6px;opacity:0.75}
.divider .dash{flex:1;height:2px;background:repeating-linear-gradient(to right, var(--fg) 0 8px, transparent 8px 14px);opacity:0.22}
.divider .spark{font-size:1.05rem}

.section{padding:22px 0 14px;scroll-margin-top:84px}
.label{display:inline-block;border:2px solid var(--fg);padding:5px 12px;background:var(--surface);transform:rotate(-1deg);font-size:0.94rem;box-shadow:2px 2px 0 rgba(45,45,45,0.08);margin-bottom:14px}
.paper{position:relative;background:var(--surface);border:2px solid var(--fg);padding:36px 32px 28px;max-width:760px;margin:0 auto;transform:rotate(-0.35deg);box-shadow:3px 3px 0 rgba(45,45,45,0.1);overflow:hidden}
.pin{position:absolute;top:-9px;left:50%;transform:translateX(-50%);width:18px;height:18px;background:var(--accent);border:2px solid var(--fg);border-radius:50%;box-shadow:0 2px 0 rgba(0,0,0,0.12)}
.paper-tag{position:absolute;top:-12px;right:18px;background:var(--postit);border:2px solid var(--fg);padding:4px 10px;font-size:0.84rem;transform:rotate(1.6deg);box-shadow:2px 2px 0 rgba(45,45,45,0.08)}
.paper-rule{position:absolute;left:56px;top:0;bottom:0;width:2px;background:rgba(255,77,77,0.18)}
.paper h2{font-size:2.15rem;margin-bottom:10px;padding-left:18px}
.drop{display:inline-block;background:var(--accent);color:#fff;padding:2px 10px;margin-right:4px;transform:rotate(-1.4deg);border:2px solid var(--fg);line-height:1;border-radius:255px 15px 225px 15px / 15px 225px 15px 255px}
.paper-text{font-size:1.18rem;line-height:1.75;padding-left:18px}
.paper-foot{font-size:1.02rem;opacity:0.7;margin-top:12px;padding-left:18px;border-left:3px solid var(--muted);margin-left:18px}
.paper-tags{display:flex;gap:8px;flex-wrap:wrap;margin-top:18px;padding-left:18px}
.ptag{border:2px solid var(--fg);padding:5px 10px;background:var(--bg);font-size:0.9rem;transform:rotate(0.4deg)}
.ptag.alt{background:var(--muted);transform:rotate(-0.5deg)}
.ptag.yellow{background:var(--postit);transform:rotate(0.8deg)}

.section-head{text-align:center}
.section-title{font-size:clamp(2rem,4vw,2.9rem)}
.section-sub{font-size:1.08rem;opacity:0.72;margin-top:6px}
.squiggle{display:block;width:100%;max-width:860px;margin:14px auto 18px;color:var(--fg)}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:20px}
.card{position:relative;background:var(--surface);border:2px solid var(--fg);padding:24px 18px;display:flex;flex-direction:column;align-items:center;text-align:center;text-decoration:none;box-shadow:4px 4px 0 0 var(--fg);min-height:188px;transition:transform 0.12s ease, box-shadow 0.12s ease}
.card:hover{transform:rotate(0.5deg) translate(-1px,-1px);box-shadow:6px 6px 0 0 var(--fg)}
.card:active{transform:translate(3px,3px);box-shadow:1px 1px 0 0 var(--fg)}
.card.c1{transform:rotate(-1deg)}
.card.c2{transform:rotate(0.85deg)}
.card.c3{transform:rotate(-0.55deg)}
.card.c4{transform:rotate(0.95deg)}
.card.c1:hover,.card.c2:hover,.card.c3:hover,.card.c4:hover{transform:rotate(0.4deg)}
.postit-card{background:var(--postit)}
.card-tape{position:absolute;top:-9px;left:50%;transform:translateX(-50%) rotate(-1deg);width:74px;height:14px;background:rgba(45,45,45,0.08);border:1px solid rgba(45,45,45,0.12)}
.icon{width:64px;height:64px;border:2px solid var(--fg);display:grid;place-items:center;font-size:1.65rem;background:var(--bg);margin-bottom:12px}
.postit-card .icon{background:var(--surface)}
.card h3{font-size:1.32rem}
.card p{font-size:1rem;opacity:0.78}
.card p.small{font-size:0.94rem;word-break:break-all}
.arrow{position:absolute;top:12px;right:14px;font-size:1.18rem;opacity:0.45}

.quote-wrap{display:flex;justify-content:center;padding:30px 0 8px}
.quote{background:var(--postit);border:2px solid var(--fg);padding:18px 22px;max-width:680px;width:100%;transform:rotate(0.45deg);box-shadow:3px 3px 0 rgba(45,45,45,0.1);text-align:center}
.quote p{font-family:'Kalam',cursive;font-size:1.16rem}
.quote span{font-size:0.94rem;opacity:0.68}

.back-to-top{position:fixed;right:20px;bottom:20px;z-index:50;display:grid;place-items:center;width:50px;height:50px;padding:0;border:2.5px solid var(--fg);background:var(--surface);color:var(--fg);cursor:pointer;box-shadow:3px 3px 0 0 var(--fg);transform:rotate(1.2deg) translateY(8px);opacity:0;visibility:hidden;transition:opacity 0.25s ease, transform 0.25s ease, visibility 0.25s, box-shadow 0.12s ease}
.back-to-top.is-visible{opacity:1;visibility:visible;transform:rotate(1.2deg) translateY(0)}
.back-to-top:hover{background:var(--postit);box-shadow:2px 2px 0 0 var(--fg);transform:rotate(0deg) translate(-1px,-1px)}
.back-to-top:active{transform:translate(2px,2px);box-shadow:none}

.footer{margin-top:44px;border-top:3px solid var(--fg);background:var(--surface);padding:28px 0 18px}
.footer-inner{display:flex;justify-content:space-between;gap:24px;flex-wrap:wrap}
.footer-title{font-size:1.38rem;display:inline-block;position:relative}
.footer-title .u{display:block;height:7px;margin-top:2px;background:url(\"data:image/svg+xml,%3Csvg width='80' height='7' viewBox='0 0 80 7' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 5 Q 10 1, 20 5 T 40 5 T 60 5 T 80 5' stroke='%232d2d2d' stroke-width='1.4' fill='none' stroke-linecap='round'/%3E%3C/svg%3E\") repeat-x}
[data-theme='dark'] .footer-title .u{background:url(\"data:image/svg+xml,%3Csvg width='80' height='7' viewBox='0 0 80 7' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 5 Q 10 1, 20 5 T 40 5 T 60 5 T 80 5' stroke='%23e8e3d9' stroke-width='1.4' fill='none' stroke-linecap='round'/%3E%3C/svg%3E\") repeat-x}
.footer-inner p{margin-top:8px;opacity:0.74}
.footer-links{display:flex;flex-direction:column;gap:6px;min-width:140px}
.footer-links a{text-decoration:none;font-size:1.06rem}
.footer-links a:hover{text-decoration:line-through;text-decoration-thickness:2px;text-decoration-color:var(--accent)}
.footer-bottom{display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;margin-top:18px;padding-top:14px;border-top:2px dashed rgba(45,45,45,0.14);font-size:0.95rem;opacity:0.68}

html.js .reveal{opacity:0;transform:translateY(16px);transition:opacity 0.6s ease, transform 0.6s cubic-bezier(0.22, 0.61, 0.36, 1)}
html.js .fade{opacity:0}
html.js .reveal.is-visible{opacity:1;transform:none}
html.js .fade.is-visible{animation:rise 0.6s ease both}
html.js .grid .card.fade.is-visible:nth-child(2){animation-delay:0.07s}
html.js .grid .card.fade.is-visible:nth-child(3){animation-delay:0.14s}
html.js .grid .card.fade.is-visible:nth-child(4){animation-delay:0.21s}

@keyframes wiggle{0%,100%{transform:rotate(12deg) translateY(-6px)}50%{transform:rotate(8deg) translateY(-2px)}}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
@keyframes rise{from{opacity:0}to{opacity:1}}
@media(max-width:920px){.hero{grid-template-columns:1fr;gap:24px}.cta-arrow,.ring,.dot{display:none}.stack{height:400px}}
@media(max-width:640px){.container{padding:0 16px}.grid{grid-template-columns:1fr}.card.c1,.card.c2,.card.c3,.card.c4{transform:rotate(-0.2deg)}.paper{padding:28px 18px 22px}.paper h2,.paper-text,.paper-foot,.paper-tags{padding-left:10px}.paper-rule{left:14px}}
@media (prefers-reduced-motion: no-preference){html{scroll-behavior:smooth}}
@media (prefers-reduced-motion: reduce){
  .bang,.dot{animation:none}
  .btn,.card,.theme-toggle{transition:none}
  html.js .reveal,html.js .fade{opacity:1 !important;transform:none !important;transition:none !important}
  html.js .fade.is-visible{animation:none !important}
}
@media print{
  .nav,.back-to-top,.theme-toggle,.skip-link,.cta-arrow,.squiggle,.divider,.hero-right,.quote-wrap,.card-tape,.card .arrow,.star,.dot,.ring,.pin,.paper-tag,.paper-rule,.tape-top,.sticker{display:none !important}
  body{background:#fff;color:#111}
  .hero{grid-template-columns:1fr;padding:10px 0}
  .hero-copy,.role,.eyebrow{opacity:1}
  .hero-title{font-size:2.6rem}
  .title-scribble{border-color:rgba(0,0,0,0.25)}
  .paper,.card,.polaroid{background:#fff;border-color:#999;box-shadow:none}
  .paper{transform:none;max-width:100%}
  .grid{grid-template-columns:1fr 1fr;gap:10px}
  .card.c1,.card.c2,.card.c3,.card.c4{transform:none}
  .icon{border-color:#999}
  .section{padding:12px 0}
  a{color:#111;text-decoration:none}
  .footer{border-color:#999;background:#fff}
  .reveal,.fade{opacity:1 !important;transform:none !important}
  .fade.is-visible{animation:none !important}
  .ctas .btn{display:none !important}
}
"
  simplifile.write(css, to: "dist/style.css")
}

fn write_javascript() -> Result(Nil, simplifile.FileError) {
  let js =
    "(function () {
  var doc = document.documentElement;

  var toggle = document.getElementById('theme-toggle');
  var themeColor = document.getElementById('theme-color');
  function syncToggle(t) {
    if (!toggle) return;
    var isDark = t === 'dark';
    toggle.setAttribute('aria-pressed', String(isDark));
    toggle.setAttribute('aria-label', isDark ? 'Switch to light mode' : 'Switch to dark mode');
    toggle.title = isDark ? 'Switch to light mode' : 'Switch to dark mode';
  }
  syncToggle(doc.getAttribute('data-theme') || 'light');
  if (toggle) {
    toggle.addEventListener('click', function () {
      var current = doc.getAttribute('data-theme');
      var next = current === 'dark' ? 'light' : 'dark';
      doc.setAttribute('data-theme', next);
      syncToggle(next);
      if (themeColor) {
        themeColor.setAttribute('content', next === 'dark' ? '#1f1d19' : '#fdfbf7');
      }
      try {
        localStorage.setItem('theme', next);
      } catch (e) {}
    });
  }

  var yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = String(new Date().getFullYear());

  var topButton = document.getElementById('back-to-top');
  if (topButton) {
    var onScroll = function () {
      var show = window.scrollY > 480;
      topButton.classList.toggle('is-visible', show);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
    topButton.addEventListener('click', function () {
      var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      window.scrollTo({ top: 0, behavior: reduce ? 'auto' : 'smooth' });
    });
  }

  var revealEls = document.querySelectorAll('.reveal, .fade');
  if ('IntersectionObserver' in window) {
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: '0px 0px -6% 0px' }
    );
    Array.prototype.forEach.call(revealEls, function (el) {
      observer.observe(el);
    });
  } else {
    Array.prototype.forEach.call(revealEls, function (el) {
      el.classList.add('is-visible');
    });
  }

  var navAbout = document.getElementById('nav-about');
  var navContact = document.getElementById('nav-contact');
  function setActive(id) {
    if (!navAbout || !navContact) return;
    var aboutOn = id === 'about';
    var contactOn = id === 'contact';
    navAbout.classList.toggle('is-active', aboutOn);
    navContact.classList.toggle('is-active', contactOn);
    if (aboutOn) navAbout.setAttribute('aria-current', 'page');
    else navAbout.removeAttribute('aria-current');
    if (contactOn) navContact.setAttribute('aria-current', 'page');
    else navContact.removeAttribute('aria-current');
  }
  if ('IntersectionObserver' in window) {
    var spy = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) setActive(entry.target.id);
        });
      },
      { rootMargin: '-45% 0px -50% 0px', threshold: 0 }
    );
    var spyTargets = document.querySelectorAll('section[id], header[id]');
    Array.prototype.forEach.call(spyTargets, function (s) { spy.observe(s); });
  }
})();
"

  simplifile.write(js, to: "dist/main.js")
}
