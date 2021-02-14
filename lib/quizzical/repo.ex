defmodule Quizzical.Repo do
  import Ecto.Query

  use Ecto.Repo,
    otp_app: :quizzical,
    adapter: Ecto.Adapters.Postgres

  def paginate(query, paginate_options) do
    %{page: page, per_page: per_page} = Map.merge(%{per_page: 100}, paginate_options)

    %{
      results: all(from q in query, offset: (^page - 1) * ^per_page, limit: ^per_page),
      total: aggregate(query, :count, :id)
    }
  end
end
