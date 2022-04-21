defmodule PdfExport.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ChromicPDF, chromic_pdf_opts()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PdfExport.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def chromic_pdf_opts() do
    [
      no_sandbox: true
    ]
  end
end
