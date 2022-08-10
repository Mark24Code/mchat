require './lambda_vnode'
require './hooks'


def m(*opt)
  VNode.m(*opt)
end

timeline = -> (opt) {
  blogs, set_blogs = Hook.use_state([
    "Wikis now support math and Mermaid diagrams",
    "Advisory Database supports GitHub Actions advisories",
    "GitHub Actions: Ubuntu 22.04 is now generally available on GitHub-hosted runners",
    "GitHub Actions: The Ubuntu 18.04 Actions runner image is being deprecated and will "
  ])
  
  cache = blogs.value.map do |blog|
    m("text", blog)
  end

  cache.push(m("source from: #{opt[:props]}"))
}

application = -> () {
  return m([
      m("Mchat v1.0"),
      m(""),
      m(timeline, { props: "github"}),
    ])
}

VNode::Render.new(application).render