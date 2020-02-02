defmodule FerryWeb.LayoutView do
  use FerryWeb, :view

  def chat_meta(nil) do
    ""
  end

  def chat_meta(token) do
    chatCfg = Application.get_env(:ferry, :chat)
    apiKey = Keyword.fetch!(chatCfg, :apiKey)
    endpoint = Keyword.fetch!(chatCfg, :endpoint)
    ~E(
      <!-- Chat -->
      <meta name="chat:jwt" content="<%= token %>">
      <meta name="chat:context" content="general">
      <meta name="chat:apiKey" content="<%= apiKey %>">
      <meta name="chat:endpoint" content="<%= endpoint %>">
    )
  end

end
