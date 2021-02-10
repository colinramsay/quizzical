defimpl Phoenix.Param, for: Quizzical.Categories.Category do
  def to_param(%{slug: slug}) do
    slug
  end
end
