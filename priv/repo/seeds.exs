# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Quizzical.Repo.insert!(%Quizzical.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{ _, science } = Quizzical.Categories.create_category(%{ name: "Science" })
Quizzical.Categories.create_category(%{ name: "Music" })
Quizzical.Categories.create_category(%{ name: "Film / Movies" })
Quizzical.Questions.create_question()

%Quizzical.Questions.Question{} |> Quizzical.Questions.Question.changeset(%{ question: "Why", answer: "Because", category_id: science.id}) |> Quizzical.Repo.insert!()

{ _, u } = Quizzical.Accounts.register_user(%{email: "hello@gotripod.com", password: "Testing123!", is_admin: true})
cs = Quizzical.Accounts.User.confirm_changeset(u)
Quizzical.Repo.update!(cs)