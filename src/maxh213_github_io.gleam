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

  let html = wrap_with_template(config, "Max Harris - Software Engineer")

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
    <link rel=\"stylesheet\" href=\"style.css\">
    <meta name=\"description\" content=\"Max Harris - Software Engineer\">
</head>
<body>
    <div class=\"gradient-bg\">
        <div class=\"container\">
            <header class=\"hero\">
                <h1 class=\"gradient-text\">" <> name <> "</h1>
                <p class=\"lead\">" <> job_title <> "</p>
            </header>
            
            <main class=\"content\">
                <section class=\"about-section\">
                    <div class=\"about-card\">
                        <h2>About</h2>
                        <p>" <> about <> "</p>
                    </div>
                </section>
                
                <section class=\"contact-section\">
                    <div class=\"contact-grid\">
                        <a href=\"" <> linkedin_url <> "\" class=\"contact-card\" target=\"_blank\" rel=\"noopener\">
                            <div class=\"contact-icon\">💼</div>
                            <h3>LinkedIn</h3>
                        </a>
                        
                        <a href=\"" <> github_url <> "\" class=\"contact-card\" target=\"_blank\" rel=\"noopener\">
                            <div class=\"contact-icon\">💻</div>
                            <h3>GitHub</h3>
                        </a>
                        
                        <a href=\"mailto:" <> email <> "\" class=\"contact-card\">
                            <div class=\"contact-icon\">✉️</div>
                            <h3>Email</h3>
                            <p>" <> email <> "</p>
                        </a>
                        
                        <a href=\"tel:" <> phone <> "\" class=\"contact-card\">
                            <div class=\"contact-icon\">📱</div>
                            <h3>Phone</h3>
                            <p>" <> phone <> "</p>
                        </a>
                    </div>
                </section>
            </main>
        </div>
    </div>
</body>
</html>"
}

fn write_css() -> Result(Nil, simplifile.FileError) {
  let css =
    ":root {
  --faff-pink: #ffaff3;
  --unnamed-blue: #a6f0fc;
  --aged-plastic-yellow: #fffbe8;
  --underwater-blue: #292d3e;
  --charcoal: #2f2f2f;
  --white: #fefefc;
  --light-gray: #f5f5f5;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  font-size: 16px;
  line-height: 1.6;
  color: var(--charcoal);
  min-height: 100vh;
}

.gradient-bg {
  background: linear-gradient(135deg, var(--faff-pink) 0%, var(--unnamed-blue) 50%, var(--aged-plastic-yellow) 100%);
  background-size: 200% 200%;
  animation: gradient-shift 15s ease infinite;
  min-height: 100vh;
  display: flex;
  align-items: center;
  padding: 2rem 0;
}

@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 2rem;
  width: 100%;
}

.hero {
  text-align: center;
  margin-bottom: 4rem;
}

.gradient-text {
  background: linear-gradient(45deg, var(--underwater-blue), var(--charcoal));
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: clamp(3rem, 8vw, 5rem);
  font-weight: 700;
  margin-bottom: 1rem;
}

.lead {
  font-size: clamp(1.5rem, 4vw, 2.5rem);
  font-weight: 300;
  color: var(--underwater-blue);
  margin-bottom: 0.5rem;
}

.subtitle {
  font-size: 1.25rem;
  color: var(--charcoal);
  opacity: 0.8;
}


.contact-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.contact-card {
  background: rgba(255, 255, 255, 0.9);
  padding: 2rem;
  border-radius: 16px;
  text-decoration: none;
  color: inherit;
  transition: all 0.3s ease;
  text-align: center;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.contact-card:hover {
  transform: translateY(-4px);
  box-shadow: 
    0 20px 40px rgba(0, 0, 0, 0.1),
    0 0 40px rgba(255, 175, 243, 0.2);
  background: rgba(255, 255, 255, 0.95);
}

.contact-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  display: block;
}

.contact-card h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  color: var(--underwater-blue);
}

.contact-card p {
  color: var(--charcoal);
  opacity: 0.8;
}

.about-section {
  display: flex;
  justify-content: center;
  margin-bottom: 3rem;
}

.about-card {
  background: rgba(255, 255, 255, 0.9);
  padding: 2.5rem;
  border-radius: 16px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  max-width: 600px;
  text-align: center;
}

.about-card h2 {
  color: var(--underwater-blue);
  margin-bottom: 1rem;
  font-size: 2rem;
}

.about-card p {
  font-size: 1.1rem;
  line-height: 1.7;
}

@media (max-width: 768px) {
  .container {
    padding: 0 1rem;
  }
  
  .contact-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .contact-card, .about-card {
    padding: 1.5rem;
  }
}

@media (prefers-reduced-motion: reduce) {
  .gradient-bg {
    animation: none;
  }
  
  .contact-card {
    transition: none;
  }
  
  .contact-card:hover {
    transform: none;
  }
}"

  simplifile.write(css, to: "dist/style.css")
}
