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
  let html = render_page(config)
  simplifile.write(html, to: "dist/index.html")
}

pub fn render_page(config: List(#(String, String))) -> String {
  wrap_with_template(config, "Max Harris - Software Engineer")
}

pub fn parse_config(content: String) -> List(#(String, String)) {
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
    <main class=\"container\">
        <header class=\"hero\">
            <h1 class=\"hero-title\">
                <span class=\"title-scribble\" aria-hidden=\"true\"></span>
                " <> name <> "
            </h1>
            <div class=\"role-wrap\">
                <p class=\"role\">" <> job_title <> "</p>
                <svg class=\"wavy\" viewBox=\"0 0 260 12\" preserveAspectRatio=\"none\" aria-hidden=\"true\"><path d=\"M2 8 Q 18 2, 36 8 T 72 8 T 108 8 T 144 8 T 180 8 T 216 8 T 252 8\" fill=\"none\" stroke=\"#ff4d4d\" stroke-width=\"3.2\" stroke-linecap=\"round\"/></svg>
            </div>
        </header>

        <div class=\"divider\" aria-hidden=\"true\"><span class=\"dash\"></span><span class=\"spark\">✦</span><span class=\"dash\"></span></div>

        <section id=\"about\" class=\"section\">
            <div class=\"paper\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">
                <div class=\"pin\" aria-hidden=\"true\"></div>
                <div class=\"paper-rule\" aria-hidden=\"true\"></div>
                <h2><span class=\"drop\">A</span>bout</h2>
                <p class=\"paper-text\">" <> about <> "</p>
            </div>
        </section>

        <section id=\"contact\" class=\"section\">
            <svg class=\"squiggle\" viewBox=\"0 0 800 28\" fill=\"none\" aria-hidden=\"true\"><path d=\"M0 14 Q 80 0, 160 14 T 320 14 T 480 14 T 640 14 T 800 14\" stroke=\"#2d2d2d\" stroke-width=\"2\" stroke-dasharray=\"8 6\" stroke-linecap=\"round\" opacity=\"0.22\"/></svg>
            <div class=\"grid\">
                <a href=\"" <> linkedin_url <> "\" target=\"_blank\" rel=\"noopener\" class=\"card c1\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">
                    <div class=\"card-tape\" aria-hidden=\"true\"></div>
                    <div class=\"icon\" style=\"border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\">💼</div>
                    <h3>LinkedIn</h3>
                    <span class=\"arrow\">↗</span>
                </a>
                <a href=\"" <> github_url <> "\" target=\"_blank\" rel=\"noopener\" class=\"card c2 postit-card\" style=\"border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;\">
                    <div class=\"icon\" style=\"border-radius: 15px 225px 15px 255px / 255px 15px 225px 15px;\">💻</div>
                    <h3>GitHub</h3>
                    <span class=\"arrow\">↗</span>
                </a>
                <a href=\"mailto:" <> email <> "\" class=\"card c3\" style=\"border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;\">
                    <div class=\"icon\" style=\"border-radius: 225px 15px 255px 15px / 15px 255px 15px 225px;\">✉️</div>
                    <h3>Email</h3>
                    <p class=\"small\">" <> email <> "</p>
                    <span class=\"arrow\">→</span>
                </a>
                <a href=\"tel:" <> phone <> "\" class=\"card c4\" style=\"border-radius: 15px 255px 15px 225px / 225px 15px 255px 15px;\">
                    <div class=\"card-tape\" aria-hidden=\"true\"></div>
                    <div class=\"icon\" style=\"border-radius: 15px 255px 15px 225px / 225px 15px 255px 15px;\">📱</div>
                    <h3>Phone</h3>
                    <p class=\"small\">" <> phone <> "</p>
                    <span class=\"arrow\">→</span>
                </a>
            </div>
        </section>
    </main>
</body>
</html>"
}

fn write_css() -> Result(Nil, simplifile.FileError) {
  let css =
    ":root{--bg:#fdfbf7;--fg:#2d2d2d;--muted:#e5e0d8;--accent:#ff4d4d;--blue:#2d5da1;--postit:#fff9c4;--line:#f1ede8}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{font-family:'Patrick Hand',cursive;background-color:var(--bg);background-image:radial-gradient(var(--muted) 1px, transparent 1px);background-size:24px 24px;color:var(--fg);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased}
h1,h2,h3,h4{font-family:'Kalam',cursive;font-weight:700;line-height:1.05}
a{color:inherit}
.container{max-width:1120px;margin:0 auto;padding:0 24px}

.hero{min-height:78vh;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:24px 0 0}
.hero-title{position:relative;font-size:clamp(3.4rem, 7.2vw, 5.6rem);letter-spacing:-0.03em;z-index:1}
.title-scribble{position:absolute;left:-10px;right:-10px;top:8%;bottom:6%;border:2.5px dashed rgba(45,45,45,0.18);transform:rotate(-1.2deg);border-radius:255px 15px 225px 15px / 15px 225px 15px 255px;z-index:-1}
.role-wrap{position:relative;display:inline-block;margin-top:6px}
.role{font-family:'Kalam',cursive;font-size:clamp(1.35rem,3vw,1.85rem);color:var(--blue)}
.wavy{position:absolute;left:-6px;right:-10px;bottom:-10px;width:108%;height:11px}

.divider{display:flex;align-items:center;gap:14px;padding:28px 0 6px;opacity:0.75}
.divider .dash{flex:1;height:2px;background:repeating-linear-gradient(to right, var(--fg) 0 8px, transparent 8px 14px);opacity:0.22}
.divider .spark{font-size:1.05rem}

.section{padding:22px 0 14px}
.label{display:inline-block;border:2px solid var(--fg);padding:5px 12px;background:#fff;transform:rotate(-1deg);font-size:0.94rem;box-shadow:2px 2px 0 rgba(45,45,45,0.08);margin-bottom:14px}
.paper{position:relative;background:#fff;border:2px solid var(--fg);padding:36px 32px 28px;max-width:760px;margin:0 auto;transform:rotate(-0.35deg);box-shadow:3px 3px 0 rgba(45,45,45,0.1);overflow:hidden}
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
.squiggle{display:block;width:100%;max-width:860px;margin:14px auto 18px}
.grid{display:grid;grid-template-columns:repeat(2,1fr);gap:20px}
.card{position:relative;background:#fff;border:2px solid var(--fg);padding:24px 18px;display:flex;flex-direction:column;align-items:center;text-align:center;text-decoration:none;box-shadow:4px 4px 0 0 var(--fg);min-height:188px;transition:transform 0.12s ease, box-shadow 0.12s ease}
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
.postit-card .icon{background:#fff}
.card h3{font-size:1.32rem}
.card p{font-size:1rem;opacity:0.78}
.card p.small{font-size:0.94rem;word-break:break-all}
.arrow{position:absolute;top:12px;right:14px;font-size:1.18rem;opacity:0.45}

.quote-wrap{display:flex;justify-content:center;padding:30px 0 8px}
.quote{background:var(--postit);border:2px solid var(--fg);padding:18px 22px;max-width:680px;width:100%;transform:rotate(0.45deg);box-shadow:3px 3px 0 rgba(45,45,45,0.1);text-align:center}
.quote p{font-family:'Kalam',cursive;font-size:1.16rem}
.quote span{font-size:0.94rem;opacity:0.68}

@media(max-width:920px){.hero{min-height:70vh}}
@media(max-width:640px){.container{padding:0 16px}.grid{grid-template-columns:1fr}.card.c1,.card.c2,.card.c3,.card.c4{transform:rotate(-0.2deg)}.paper{padding:28px 18px 22px}.paper h2,.paper-text,.paper-foot,.paper-tags{padding-left:10px}.paper-rule{left:14px}}
@media(prefers-reduced-motion:reduce){.card{transition:none}}
"
  simplifile.write(css, to: "dist/style.css")
}
