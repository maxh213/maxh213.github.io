import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import maxh213_github_io
import simplifile

pub fn main() {
  gleeunit.main()
}

const original_about = "Software Engineer at Anima International, focusing on technology solutions for animal welfare advocacy and lobbying for improved chicken welfare standards."

fn sample_config() -> List(#(String, String)) {
  [
    #("name", "Max Harris"),
    #("title", "Software Engineer"),
    #("about", original_about),
    #("linkedin_url", "https://www.linkedin.com/in/max-harris-53435a113/"),
    #("github_url", "https://github.com/maxh213"),
    #("email", "max.o.harris@outlook.com"),
    #("phone", "+447497866190"),
  ]
}

pub fn djot_content_is_unchanged_test() {
  let assert Ok(content) = simplifile.read("content/index.djot")
  let config = maxh213_github_io.parse_config(content)

  config
  |> list.key_find("name")
  |> should.equal(Ok("Max Harris"))

  config
  |> list.key_find("title")
  |> should.equal(Ok("Software Engineer"))

  config
  |> list.key_find("about")
  |> should.equal(Ok(original_about))

  config
  |> list.key_find("email")
  |> should.equal(Ok("max.o.harris@outlook.com"))

  config
  |> list.key_find("phone")
  |> should.equal(Ok("+447497866190"))
}

pub fn original_copy_is_present_test() {
  let html = maxh213_github_io.render_page(sample_config())

  html
  |> string.contains(original_about)
  |> should.equal(True)

  html
  |> string.contains("Max Harris")
  |> should.equal(True)

  html
  |> string.contains("Software Engineer")
  |> should.equal(True)

  html
  |> string.contains("LinkedIn")
  |> should.equal(True)

  html
  |> string.contains("GitHub")
  |> should.equal(True)

  html
  |> string.contains("Email")
  |> should.equal(True)

  html
  |> string.contains("Phone")
  |> should.equal(True)

  html
  |> string.contains("max.o.harris@outlook.com")
  |> should.equal(True)

  html
  |> string.contains("+447497866190")
  |> should.equal(True)
}

pub fn chrome_is_removed_test() {
  let html = maxh213_github_io.render_page(sample_config())

  [
    "<nav", "</nav>", "<footer", "</footer>", "MH", "class=\"initials\"",
    "polaroid", "nav-link", "footer-links",
  ]
  |> list.each(fn(phrase) {
    html
    |> string.contains(phrase)
    |> should.equal(False)
  })
}

pub fn invented_copy_is_absent_test() {
  let html = maxh213_github_io.render_page(sample_config())

  [
    "scribbles", "open to thoughtful collaborations",
    "sketching systems on napkins", "Say hello", "See GitHub", "Gleam on Erlang",
    "London", "for the chickens", "drawn with care", "well-made tools",
    "Get in touch", "Pin a note", "Let's connect", "needlessly complicated",
    "Sketching better futures", "drawn by hand", "note #01", "@maxh213",
    "Contact",
  ]
  |> list.each(fn(phrase) {
    html
    |> string.contains(phrase)
    |> should.equal(False)
  })
}
