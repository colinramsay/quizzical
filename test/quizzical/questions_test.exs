defmodule Quizzical.QuestionsTest do
  use Quizzical.DataCase

  alias Quizzical.Questions
  import Quizzical.AccountsFixtures

  describe "questions" do
    alias Quizzical.Questions.Question

    @valid_attrs %{question: "some question", answer: "some answer"}
    @update_attrs %{question: "some updated question", answer: "some updated answer"}
    @invalid_attrs %{question: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questions.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions().results == [question]
    end

    test "not_hidden/1 returns questions not hidden by user" do
      user = user_fixture()
      question_hidden = question_fixture()
      question_shown = question_fixture()

      Questions.hide_question(question_hidden, user)

      assert hd(Questions.not_hidden(user)).id == question_shown.id
      assert hd(Questions.hidden(user)).id == question_hidden.id
    end

    test "hide_question/1 adds join table entry" do
      user = user_fixture()
      question = question_fixture()
      Questions.hide_question(question, user)

      user = Quizzical.Repo.preload(user, :hidden_questions)

      assert hd(user.hidden_questions).id == question.id
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Questions.create_question(@valid_attrs)
      assert question.question == "some question"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Questions.update_question(question, @update_attrs)
      assert question.question == "some updated question"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
