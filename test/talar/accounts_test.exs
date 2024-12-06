defmodule Talar.AccountsTest do
  use Talar.DataCase

  alias Talar.Accounts
  alias Talar.Factory
  alias Talar.Accounts.User

  describe "users" do
    # import Talar.AccountsFixtures

    # @invalid_attrs %{name: nil, email: nil}

    @valid_attrs %{
      name: "Example User",
      email: "user@example.com",
      password: "Foo22Bar!",
      password_confirmation: "Foo22Bar!"
    }

    test "email too long does not insert user" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | email: String.duplicate("a", 244) <> "@example.com"
               })
    end

    test "valid email addresses insert user" do
      valid_addresses = [
        "user@example.com",
        "USER@foo.COM",
        "A_US-ER@foo.bar.org",
        "first.last@foo.jp",
        "alice+bob@baz.cn"
      ]

      for valid_address <- valid_addresses do
        assert {:ok, %User{}} =
                 Accounts.create_user(%{
                   @valid_attrs
                   | email: valid_address
                 })
      end
    end

    test "invalid email addresses do not insert user" do
      invalid_addresses = [
        "user@example,com",
        "user_at_foo.org",
        "user.name@example.",
        "foo@bar_baz.com",
        "foo@bar+baz.com"
      ]

      for invalid_address <- invalid_addresses do
        assert {:error, %Ecto.Changeset{}} =
                 Accounts.create_user(%{
                   @valid_attrs
                   | email: invalid_address
                 })
      end
    end

    test "existing email address does not insert user" do
      Accounts.create_user(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | email: String.upcase(@valid_attrs.email)
               })
    end

    test "email address is inserted as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM"

      assert {:ok, %User{email: "foo@example.com"}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | email: mixed_case_email
               })
    end
  end

  test "password left blank does not insert user" do
    blank_password = String.duplicate(" ", 6)

    assert {:error, %Ecto.Changeset{}} =
             Accounts.create_user(%{
               @valid_attrs
               | password: blank_password,
                 password_confirmation: blank_password
             })
  end

  test "password too short does not insert user" do
    short_password = String.duplicate("a", 5)

    assert {:error, %Ecto.Changeset{}} =
             Accounts.create_user(%{
               @valid_attrs
               | password: short_password,
                 password_confirmation: short_password
             })
  end

  test "delete_user/1 deletes the user" do
    user = Factory.insert(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    assert Accounts.get_user(user.id) == nil
  end

  describe "get_user/1" do
    test "returns the user with given id" do
      %User{id: id} = Factory.insert(:user)
      assert %User{id: ^id} = Accounts.get_user(id)
    end

    test "returns nil if the user is not found" do
      invalid_user_id = 111
      assert nil == Accounts.get_user(invalid_user_id)
    end
  end

  describe "get_user!/1" do
    test "returns the user with given id" do
      %User{id: id} = Factory.insert(:user)
      assert %User{id: ^id} = Accounts.get_user!(id)
    end

    test "raises Ecto.NoResultsError if the user is not found" do
      invalid_user_id = 111

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(invalid_user_id)
      end
    end
  end

  describe "get_user_by/1" do
    test "returns the user with given email field" do
      %User{email: email} = Factory.insert(:user)
      assert %User{email: ^email} = Accounts.get_user_by(email: email)
    end

    test "returns nil if the user is not found" do
      invalid_user_email = "doesnotexist@example.com"

      assert nil ==
               Accounts.get_user_by(email: invalid_user_email)
    end
  end

  describe "get_user_by!/1" do
    test "returns the user with given email field" do
      %User{email: email} = Factory.insert(:user)
      assert %User{email: ^email} = Accounts.get_user_by!(email: email)
    end

    test "raises Ecto.NoResultsError if the user is not found" do
      invalid_user_email = "doesnotexist@example.com"

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user_by!(email: invalid_user_email)
      end
    end
  end

  test "list_users/0 returns all users" do
    %User{id: id1} = Factory.insert(:user)
    %User{id: id2} = Factory.insert(:user)
    assert [%User{id: ^id1}, %User{id: ^id2}] = Accounts.list_users()
  end

  describe "create_user/1" do
    test "with valid attributes inserts user" do
      assert {:ok, %User{} = _user} = Accounts.create_user(@valid_attrs)
    end

    test "name left blank does not insert user" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{@valid_attrs | name: "      "})
    end

    test "email left blank does not insert user" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{@valid_attrs | email: "      "})
    end

    test "name too long does not insert user" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{@valid_attrs | name: String.duplicate("a", 51)})
    end

    test "email too long does not insert user" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | email: String.duplicate("a", 244) <> "@example.com"
               })
    end

    test "valid email addresses insert user" do
      valid_addresses = [
        "user@example.com",
        "USER@foo.COM",
        "A_US-ER@foo.bar.org",
        "first.last@foo.jp",
        "alice+bob@baz.cn"
      ]

      for valid_address <- valid_addresses do
        assert {:ok, %User{}} =
                 Accounts.create_user(%{
                   @valid_attrs
                   | email: valid_address
                 })
      end
    end

    test "invalid email addresses do not insert user" do
      invalid_addresses = [
        "user@example,com",
        "user_at_foo.org",
        "user.name@example.",
        "foo@bar_baz.com",
        "foo@bar+baz.com"
      ]

      for invalid_address <- invalid_addresses do
        assert {:error, %Ecto.Changeset{}} =
                 Accounts.create_user(%{
                   @valid_attrs
                   | email: invalid_address
                 })
      end
    end

    test "existing email address does not insert user" do
      Factory.insert(:user, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | email: String.upcase(@valid_attrs.email)
               })
    end

    test "password left blank does not insert user" do
      blank_password = String.duplicate(" ", 6)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | password: blank_password,
                   password_confirmation: blank_password
               })
    end

    test "password too short does not insert user" do
      short_password = String.duplicate("a", 5)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 @valid_attrs
                 | password: short_password,
                   password_confirmation: short_password
               })
    end
  end

  describe "authenticate_by_email_and_pass/2" do
    @email "user@example.com"
    @pass "123456"

    setup do
      {:ok,
       user:
         Factory.insert(:user,
           email: @email,
           password: @pass,
           password_hash: Argon2.hash_pwd_salt(@pass)
         )}
    end

    test "returns user with correct password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_by_email_and_pass(@email, @pass)
    end

    test "returns unauthorized error with invalid password" do
      assert {:error, :unauthorized} = Accounts.authenticate_by_email_and_pass(@email, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} =
               Accounts.authenticate_by_email_and_pass("bad@email.com", @pass)
    end
  end
end
