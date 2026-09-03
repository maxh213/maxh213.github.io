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
  Ok(Nil)
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

fn wrap_with_template(config: List(#(String, String)), title: String) -> String {
  let name = get_config_value(config, "name")
  let job_title = get_config_value(config, "title")
  let about = get_config_value(config, "about")
  let linkedin_url = get_config_value(config, "linkedin_url")
  let github_url = get_config_value(config, "github_url")
  let email = get_config_value(config, "email")
  let phone = get_config_value(config, "phone")

  "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>" <> title <> "</title>
    <meta name=\"description\" content=\"Max Harris - Software Engineer\">
    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">
    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>
    <link href=\"https://fonts.googleapis.com/css2?family=Kalam:wght@700&family=Patrick+Hand&display=swap\" rel=\"stylesheet\">
    <link rel=\"stylesheet\" href=\"style.css\">
</head>
<body>
    <nav class=\"top-nav\">
        <div class=\"container nav-inner\">
            <a href=\"#\" class=\"logo\">MH<span class=\"logo-dot\">.</span> <span class=\"logo-script\">scribbles &amp; code</span></a>
            <div class=\"nav-links\">
                <a href=\"#about\" class=\"nav-link\">About</a>
                <a href=\"#contact\" class=\"nav-link\">Contact</a>
                <a href=\"" <> github_url <> "\" target=\"_blank\" rel=\"noopener\" class=\"nav-link nav-link-red\">GitHub →</a>
            </div>
        </div>
    </nav>

    <main class=\"container\">
        <header class=\"hero\">
            <div class=\"hero-text\">
                <div class=\"sticky-tag\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\"><span>✦ available for new ideas</span></div>
                <h1 class=\"hero-title\">" <> name <> "<span class=\"twist\">!</span></h1>
                <div class=\"wavy-wrap\">
                    <p class=\"lead\">" <> job_title <> "</p>
                    <svg class=\"wavy-underline\" viewBox=\"0 0 300 12\" preserveAspectRatio=\"none\" aria-hidden=\"true\"><path d=\"M2 8 Q 20 2, 40 8 T 80 8 T 120 8 T 160 8 T 200 8 T 240 8 T 280 8\" fill=\"none\" stroke=\"#ff4d4d\" stroke-width=\"3\" stroke-linecap=\"round\"/></svg>
                </div>
                <p class=\"hero-sub\">I build thoughtful tech for animal welfare at Anima International — lobbying for better chicken welfare &amp; sketching systems on the back of napkins.</p>
                <div class=\"hero-ctas\">
                    <a href=\"mailto:" <> email <> "\" class=\"btn btn-primary\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">Say hello ✉️</a>
                    <a href=\"" <> github_url <> "\" target=\"_blank\" rel=\"noopener\" class=\"btn btn-secondary\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">See GitHub</a>
                </div>
                <svg class=\"hero-arrow\" viewBox=\"0 0 120 60\" fill=\"none\" aria-hidden=\"true\"><path d=\"M5 35 Q 40 5, 75 28 T 105 32\" stroke=\"#2d2d2d\" stroke-width=\"2.5\" stroke-dasharray=\"6 4\" stroke-linecap=\"round\"/><path d=\"M98 22 L105 32 L93 40\" stroke=\"#2d2d2d\" stroke-width=\"2.5\" stroke-linecap=\"round\" stroke-linejoin=\"round\" fill=\"none\"/></svg>
            </div>

            <div class=\"hero-art\">
                <div class=\"art-frame\" style=\"border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;\">
                    <div class=\"tape\" aria-hidden=\"true\"></div>
                    <div class=\"corner tl\"></div><div class=\"corner tr\"></div><div class=\"corner bl\"></div><div class=\"corner br\"></div>
                    <div class=\"art-inner\">
                        <div class=\"art-initials\">MH</div>
                        <p class=\"art-caption\">software engineer<br><span>Anima International</span></p>
                        <div class=\"art-dashed\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">✎ sketched with care</div>
                    </div>
                </div>
                <div class=\"bouncing-dot\" aria-hidden=\"true\"></div>
                <div class=\"scribble-circle\" aria-hidden=\"true\"></div>
            </div>
        </header>

        <div class=\"sketch-divider\" aria-hidden=\"true\"><span></span><span>✦</span><span></span></div>

        <section id=\"about\" class=\"section about-section\">
            <div class=\"section-label\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">— about —</div>
            <div class=\"about-card\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">
                <div class=\"tack\" aria-hidden=\"true\"></div>
                <div class=\"postit\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">note #01</div>
                <h2><span class=\"dropcap\">A</span>bout</h2>
                <p>" <> about <> "</p>
                <div class=\"about-meta\">
                    <span class=\"meta-tag\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">Gleam ✦ Erlang</span>
                    <span class=\"meta-tag\" style=\"border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;\">advocacy tech</span>
                    <span class=\"meta-tag\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">chickens 🐔</span>
                </div>
            </div>
        </section>

        <section id=\"contact\" class=\"section contact-section\">
            <div class=\"section-head\">
                <h2 class=\"section-title\">Get in touch</h2>
                <p class=\"section-sub\">Pick a sticky — I read them all, promise.</p>
            </div>

            <svg class=\"squiggle\" viewBox=\"0 0 800 40\" fill=\"none\" aria-hidden=\"true\"><path d=\"M0 20 Q 80 0, 160 20 T 320 20 T 480 20 T 640 20 T 800 20\" stroke=\"#2d2d2d\" stroke-width=\"2\" stroke-dasharray=\"8 6\" stroke-linecap=\"round\" opacity=\"0.25\"/></svg>

            <div class=\"contact-grid\">
                <a href=\"" <> linkedin_url <> "\" class=\"contact-card tilt-l\" target=\"_blank\" rel=\"noopener\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">
                    <div class=\"contact-tape\"></div>
                    <div class=\"icon-circle\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">💼</div>
                    <h3>LinkedIn</h3>
                    <p>Let's connect</p>
                    <span class=\"card-arrow\">↗</span>
                </a>
                <a href=\"" <> github_url <> "\" class=\"contact-card tilt-r\" target=\"_blank\" rel=\"noopener\" style=\"border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;\">
                    <div class=\"contact-tape\"></div>
                    <div class=\"icon-circle\" style=\"border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;\">💻</div>
                    <h3>GitHub</h3>
                    <p>@maxh213</p>
                    <span class=\"card-arrow\">↗</span>
                </a>
                <a href=\"mailto:" <> email <> "\" class=\"contact-card tilt-l2\" style=\"border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;\">
                    <div class=\"icon-circle\" style=\"border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;\">✉️</div>
                    <h3>Email</h3>
                    <p class=\"small\">" <> email <> "</p>
                    <span class=\"card-arrow\">→</span>
                </a>
                <a href=\"tel:" <> phone <> "\" class=\"contact-card tilt-r2\" style=\"border-radius: 15px 255px 15px 225px / 225px 15px 255px 15px;\">
                    <div class=\"icon-circle\" style=\"border-radius: 15px 255px 15px 225px / 225px 15px 255px 15px;\">📱</div>
                    <h3>Phone</h3>
                    <p class=\"small\">" <> phone <> "</p>
                    <span class=\"card-arrow\">→</span>
                </a>
            </div>
        </section>

        <div class=\"quote-wrap\">
            <div class=\"quote-card\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">
                <p>“Built needlessly complicated with Gleam — exactly how I like to learn.”</p>
                <span>— the original README</span>
            </div>
        </div>
    </main>

    <footer class=\"footer\">
        <div class=\"container footer-inner\">
            <div>
                <h4 class=\"footer-title\">Max Harris<span class=\"wavy-sm\"></span></h4>
                <p>Software Engineer · Anima International<br>Sketching better futures for animals.</p>
            </div>
            <div class=\"footer-links\">
                <a href=\"" <> linkedin_url <> "\" target=\"_blank\" rel=\"noopener\">LinkedIn</a>
                <a href=\"" <> github_url <> "\" target=\"_blank\" rel=\"noopener\">GitHub</a>
                <a href=\"mailto:" <> email <> "\">Email</a>
            </div>
        </div>
        <div class=\"container footer-bottom\">
            <span>© 2026 — drawn by hand, shipped with Gleam ✎</span>
            <span class=\"footer-doodle\" aria-hidden=\"true\">〰〰〰</span>
        </div>
    </footer>
</body>
</html>"
}

fn write_css() -> Result(Nil, simplifile.FileError) {
  let css =
    ":root{
  --bg:#fdfbf7;
  --fg:#2d2d2d;
  --muted:#e5e0d8;
  --accent:#ff4d4d;
  --blue:#2d5da1;
  --postit:#fff9c4;
  --wobbly:255px 15px 225px 15px / 15px 225px 15px 255px;
  --wobbly-alt:15px 225px 15px 255px / 255px 15px 225px 15px;
  --wobbly-md:255px 15px 225px 15px / 15px 225px 15px 255px;
}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{
  font-family:'Patrick Hand',cursive;
  background-color:var(--bg);
  background-image:radial-gradient(var(--muted) 1px, transparent 1px);
  background-size:24px 24px;
  color:var(--fg);
  line-height:1.6;
  -webkit-font-smoothing:antialiased;
  overflow-x:hidden;
}
h1,h2,h3,h4{font-family:'Kalam',cursive;font-weight:700;line-height:1.1}
a{color:inherit}
.container{max-width:1080px;margin:0 auto;padding:0 24px}

.top-nav{position:sticky;top:0;z-index:20;background:rgba(253,251,247,0.9);backdrop-filter:blur(6px);border-bottom:2px dashed rgba(45,45,45,0.15);padding:14px 0}
.nav-inner{display:flex;justify-content:space-between;align-items:center;gap:16px;flex-wrap:wrap}
.logo{font-family:'Kalam',cursive;font-weight:700;font-size:1.35rem;text-decoration:none;display:flex;align-items:baseline;gap:6px}
.logo-dot{color:var(--accent);font-size:1.8rem;line-height:1}
.logo-script{font-family:'Patrick Hand',cursive;font-weight:400;font-size:1rem;opacity:0.7}
.nav-links{display:flex;gap:18px;align-items:center;flex-wrap:wrap}
.nav-link{font-size:1.05rem;text-decoration:none;position:relative;padding-bottom:2px}
.nav-link::after{content:'';position:absolute;left:0;right:0;bottom:-4px;height:6px;background:url(\"data:image/svg+xml,%3Csvg width='60' height='6' viewBox='0 0 60 6' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 4 Q 10 1, 20 4 T 40 4 T 60 4' stroke='%23ff4d4d' stroke-width='1.6' fill='none' stroke-linecap='round'/%3E%3C/svg%3E\") repeat-x;opacity:0;transform:translateY(2px);transition:0.15s}
.nav-link:hover::after{opacity:1;transform:translateY(0)}
.nav-link-red:hover{color:var(--accent)}

.hero{display:grid;grid-template-columns:1fr 380px;gap:32px;align-items:center;padding:56px 0 20px}
.hero-text{position:relative}
.sticky-tag{display:inline-block;background:var(--postit);border:2px solid var(--fg);padding:6px 14px;transform:rotate(-1.2deg);font-size:0.95rem;margin-bottom:14px;box-shadow:2px 2px 0 rgba(45,45,45,0.12)}
.hero-title{font-size:clamp(3.2rem, 7vw, 5.2rem);letter-spacing:-0.02em}
.twist{display:inline-block;color:var(--accent);transform:rotate(12deg) translateY(-4px);margin-left:2px;animation:wiggle 2.5s ease-in-out infinite}
.wavy-wrap{position:relative;display:inline-block;margin-top:4px}
.lead{font-family:'Kalam',cursive;font-size:clamp(1.4rem,3vw,1.9rem);color:var(--blue)}
.wavy-underline{position:absolute;left:-4px;right:-8px;bottom:-8px;width:108%;height:10px}
.hero-sub{font-size:1.2rem;max-width:48ch;margin-top:18px;opacity:0.85}
.hero-ctas{display:flex;gap:14px;margin-top:24px;flex-wrap:wrap;align-items:center;position:relative}
.hero-arrow{position:absolute;left:220px;top:-18px;width:110px;height:54px;opacity:0.9;transform:rotate(-2deg)}
.btn{display:inline-flex;align-items:center;justify-content:center;min-height:48px;padding:10px 22px;border:3px solid var(--fg);font-family:'Patrick Hand',cursive;font-size:1.15rem;text-decoration:none;cursor:pointer;transition:all 0.12s ease;box-shadow:4px 4px 0 0 var(--fg);background:#fff;color:var(--fg);transform:rotate(-0.3deg)}
.btn:hover{background:var(--accent);color:#fff;box-shadow:2px 2px 0 0 var(--fg);transform:translate(2px,2px) rotate(0deg)}
.btn:active{box-shadow:none;transform:translate(4px,4px)}
.btn-secondary{background:var(--muted)}
.btn-secondary:hover{background:var(--blue)}

.hero-art{position:relative;display:flex;justify-content:center}
.art-frame{background:#fff;border:2px solid var(--fg);padding:26px 22px 22px;min-height:360px;width:100%;max-width:360px;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;transform:rotate(1.1deg);box-shadow:4px 4px 0 0 var(--fg);position:relative}
.tape{position:absolute;top:-14px;left:50%;width:110px;height:22px;background:rgba(45,45,45,0.09);border:1px solid rgba(45,45,45,0.12);transform:translateX(-50%) rotate(-1.5deg);backdrop-filter:blur(1px)}
.corner{position:absolute;width:18px;height:18px;border-color:var(--fg);border-style:solid}
.corner.tl{top:10px;left:10px;border-width:3px 0 0 3px;border-radius:4px 0 0 0}
.corner.tr{top:10px;right:10px;border-width:3px 3px 0 0;border-radius:0 4px 0 0}
.corner.bl{bottom:10px;left:10px;border-width:0 0 3px 3px;border-radius:0 0 0 4px}
.corner.br{bottom:10px;right:10px;border-width:0 3px 3px 0;border-radius:0 0 4px 0}
.art-inner{display:flex;flex-direction:column;align-items:center;gap:10px}
.art-initials{font-family:'Kalam',cursive;font-weight:700;font-size:4.2rem;line-height:1;border:3px solid var(--fg);width:124px;height:124px;display:grid;place-items:center;transform:rotate(-1deg);background:var(--bg);box-shadow:2px 2px 0 rgba(45,45,45,0.08);border-radius:255px 15px 225px 15px / 15px 225px 15px 255px}
.art-caption{font-size:1.15rem;line-height:1.3}
.art-caption span{color:var(--blue)}
.art-dashed{border:2px dashed var(--fg);padding:6px 12px;font-size:0.95rem;transform:rotate(-0.8deg);background:var(--postit);margin-top:6px}
.bouncing-dot{position:absolute;top:-10px;right:18px;width:18px;height:18px;background:var(--accent);border:2px solid var(--fg);border-radius:50%;animation:float 3s ease-in-out infinite;box-shadow:2px 2px 0 var(--fg)}
.scribble-circle{position:absolute;bottom:-14px;left:-10px;width:54px;height:54px;border:2px dashed rgba(45,45,45,0.25);border-radius:50%;transform:rotate(-8deg)}

.sketch-divider{display:flex;align-items:center;gap:14px;padding:18px 0 8px;opacity:0.7}
.sketch-divider span:first-child,.sketch-divider span:last-child{flex:1;height:2px;background:repeating-linear-gradient(to right,var(--fg) 0 8px, transparent 8px 14px);opacity:0.25}
.sketch-divider span:nth-child(2){font-size:1.1rem}

.section{padding:28px 0 20px}
.section-label{display:inline-block;border:2px solid var(--fg);padding:5px 12px;background:#fff;transform:rotate(-1deg);font-size:0.95rem;margin-bottom:14px;box-shadow:2px 2px 0 rgba(45,45,45,0.08)}
.about-section{display:flex;flex-direction:column;align-items:center}
.about-card{background:#fff;border:2px solid var(--fg);padding:32px 28px 28px;max-width:680px;width:100%;text-align:center;transform:rotate(-0.7deg);box-shadow:3px 3px 0 rgba(45,45,45,0.1);position:relative}
.tack{position:absolute;top:-10px;left:50%;transform:translateX(-50%);width:18px;height:18px;background:var(--accent);border:2px solid var(--fg);border-radius:50%;box-shadow:0 1px 0 var(--fg), 0 2px 0 rgba(0,0,0,0.1)}
.postit{position:absolute;top:-14px;right:18px;background:var(--postit);border:2px solid var(--fg);padding:4px 10px;font-size:0.85rem;transform:rotate(1.8deg);box-shadow:2px 2px 0 rgba(45,45,45,0.08)}
.about-card h2{font-size:2.2rem;margin-bottom:10px}
.dropcap{display:inline-block;background:var(--accent);color:#fff;padding:2px 10px;margin-right:4px;transform:rotate(-1.5deg);border:2px solid var(--fg);border-radius:255px 15px 225px 15px / 15px 225px 15px 255px;line-height:1}
.about-card p{font-size:1.15rem;line-height:1.7}
.about-meta{display:flex;gap:8px;justify-content:center;flex-wrap:wrap;margin-top:16px}
.meta-tag{border:2px solid var(--fg);padding:5px 10px;font-size:0.9rem;background:var(--bg);transform:rotate(0.6deg)}
.meta-tag:nth-child(2){background:var(--muted);transform:rotate(-0.6deg)}
.meta-tag:nth-child(3){background:var(--postit);transform:rotate(0.9deg)}

.section-head{text-align:center;margin-bottom:10px}
.section-title{font-size:clamp(2rem,4vw,2.8rem)}
.section-sub{font-size:1.1rem;opacity:0.75;margin-top:6px}
.squiggle{display:block;width:100%;max-width:840px;margin:10px auto 18px;opacity:0.9}

.contact-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:22px}
.contact-card{position:relative;background:#fff;border:2px solid var(--fg);padding:22px 18px;display:flex;flex-direction:column;align-items:center;text-align:center;text-decoration:none;transition:transform 0.12s ease, box-shadow 0.12s ease;box-shadow:4px 4px 0 0 var(--fg);min-height:190px}
.contact-card:hover{transform:rotate(0.8deg) translate(-1px,-1px);box-shadow:6px 6px 0 0 var(--fg)}
.contact-card:active{transform:translate(2px,2px);box-shadow:2px 2px 0 0 var(--fg)}
.tilt-l{transform:rotate(-1.1deg)}
.tilt-r{transform:rotate(0.9deg)}
.tilt-l2{transform:rotate(-0.6deg)}
.tilt-r2{transform:rotate(1deg)}
.contact-tape{position:absolute;top:-8px;left:50%;transform:translateX(-50%) rotate(-1deg);width:70px;height:14px;background:rgba(45,45,45,0.08);border:1px solid rgba(45,45,45,0.1)}
.icon-circle{width:62px;height:62px;border:2px solid var(--fg);display:grid;place-items:center;font-size:1.7rem;background:var(--bg);margin-bottom:12px}
.contact-card h3{font-size:1.35rem}
.contact-card p{font-size:1rem;opacity:0.8}
.contact-card p.small{font-size:0.95rem;word-break:break-all}
.card-arrow{position:absolute;top:12px;right:14px;font-size:1.2rem;opacity:0.5}

.quote-wrap{display:flex;justify-content:center;padding:26px 0 10px}
.quote-card{background:var(--postit);border:2px solid var(--fg);padding:16px 20px;max-width:640px;width:100%;transform:rotate(0.6deg);box-shadow:3px 3px 0 rgba(45,45,45,0.1);text-align:center}
.quote-card p{font-family:'Kalam',cursive;font-size:1.15rem}
.quote-card span{font-size:0.95rem;opacity:0.7}

.footer{margin-top:40px;border-top:3px solid var(--fg);background:#fff;padding:28px 0 18px;transform:rotate(0.15deg)}
.footer-inner{display:flex;justify-content:space-between;gap:24px;flex-wrap:wrap}
.footer-title{font-size:1.4rem;position:relative;display:inline-block}
.wavy-sm{display:block;height:6px;margin-top:2px;background:url(\"data:image/svg+xml,%3Csvg width='80' height='6' viewBox='0 0 80 6' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 4 Q 10 1, 20 4 T 40 4 T 60 4 T 80 4' stroke='%232d2d2d' stroke-width='1.4' fill='none' stroke-linecap='round'/%3E%3C/svg%3E\") repeat-x}
.footer-inner p{margin-top:8px;font-size:1rem;opacity:0.75}
.footer-links{display:flex;flex-direction:column;gap:6px;min-width:140px}
.footer-links a{text-decoration:none;font-size:1.05rem}
.footer-links a:hover{text-decoration:line-through;text-decoration-thickness:2px;text-decoration-color:var(--accent)}
.footer-bottom{display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;margin-top:18px;padding-top:14px;border-top:2px dashed rgba(45,45,45,0.15);font-size:0.95rem;opacity:0.7}

@keyframes wiggle{0%,100%{transform:rotate(12deg) translateY(-4px)}50%{transform:rotate(8deg) translateY(-2px)}}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}

@media(max-width:900px){
  .hero{grid-template-columns:1fr;gap:22px}
  .hero-arrow,.bouncing-dot,.scribble-circle{display:none}
  .art-frame{min-height:300px}
}
@media(max-width:640px){
  .container{padding:0 16px}
  .contact-grid{grid-template-columns:1fr}
  .tilt-l,.tilt-r,.tilt-l2,.tilt-r2{transform:rotate(-0.4deg)}
  .contact-card:hover{transform:rotate(0.4deg)}
  .footer-inner{flex-direction:column}
}
@media(prefers-reduced-motion:reduce){
  .twist,.bouncing-dot{animation:none}
  .btn,.contact-card{transition:none}
}
"
  simplifile.write(css, to: "dist/style.css")
}
