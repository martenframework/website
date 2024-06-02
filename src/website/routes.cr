module Website
  ROUTES = Marten::Routing::Map.draw do
    path "/", HomeHandler, name: "home"
    path "/news", NewsListHandler, name: "news_list"
    path "/news/page/<page:int>", NewsListHandler, name: "news_list_by_page"
    path "/news/<slug:str>", NewsDetailHandler, name: "news_detail"
    path "/team", TeamHandler, name: "team"
    path "/chat", ChatHandler, name: "chat"
    path "/code-of-conduct", CodeOfConductHandler, name: "code_of_conduct"
    path "/robots.txt", RobotsHandler, name: "robots"
    path "/sitemap.xml", SitemapHandler, name: "sitemap"
    # path "/bad", BadHandler, name: "bad"
  end
end
