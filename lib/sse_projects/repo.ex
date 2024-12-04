defmodule SseProjects.Repo do
  use Ecto.Repo,
    otp_app: :sse_projects,
    adapter: Ecto.Adapters.Postgres
end
