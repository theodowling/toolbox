defmodule Ferry.CRMTest do
  use Ferry.DataCase

  alias Ferry.CRM

  # Contacts
  # ==============================================================================
  # NOTE: There is nothing that tests the creation / update / deletion of
  #       associated emails and phone numbers at the same time.  Individual
  #       tests of those associations is fine for now, but if related bugs pop
  #       up the associations should be tested together as well.
  describe "contacts" do
    alias Ferry.CRM.Contact

    # Data & Helpers
    # ----------------------------------------------------------

    @valid_attrs %{
      typical: %{label: "General Inquiries", description: "Hit us up!"},
      min: %{}
    }

    @update_attrs %{
      typical: %{
        label: "Distribution - Muhammad",
        description:
          "Muhammad handles our distribution.  Contact him regarding the warehouse and to coordinate on shipments."
      }
    }

    @invalid_attrs %{
      too_long: %{
        label:
          "This is really way too long. xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      }
    }

    def contact_fixture(owner, attrs \\ %{}) do
      attrs = Enum.into(attrs, @valid_attrs.typical)
      {:ok, contact} = CRM.create_contact(owner, attrs)

      contact
    end

    def group_and_project_fixtures() do
      group = insert(:group)
      project = insert(:project, %{group: group})
      {group, project}
    end

    # Tests
    # ----------------------------------------------------------
    # NOTE: Functions like create_contact/2 which are required to distinguish
    #       between contact owners (groups or projects) must test with both.
    #       Other functions like list_contacts/0 may only test with one.
    test "list_contacts/1 returns all contacts for a group" do
      {group, project} = group_and_project_fixtures()
      {group2, _} = group_and_project_fixtures()

      # no contacts
      assert CRM.list_contacts(group) == []

      # 1 contact
      contact1 = contact_fixture(group)
      assert CRM.list_contacts(group) == [contact1]

      # n contacts
      contact2 = contact_fixture(group)
      assert CRM.list_contacts(group) == [contact1, contact2]

      # only contacts for that group
      _ = contact_fixture(group2)
      _ = contact_fixture(project)
      assert CRM.list_contacts(group) == [contact1, contact2]
    end

    test "list_contacts/1 returns all contacts for a project" do
      {group, project} = group_and_project_fixtures()
      {_, project2} = group_and_project_fixtures()

      # no contacts
      assert CRM.list_contacts(project) == []

      # 1 contact
      contact1 = contact_fixture(project)
      assert CRM.list_contacts(project) == [contact1]

      # n contacts
      contact2 = contact_fixture(project)
      assert CRM.list_contacts(project) == [contact1, contact2]

      # only contacts for group
      _ = contact_fixture(group)
      _ = contact_fixture(project2)
      assert CRM.list_contacts(project) == [contact1, contact2]
    end

    test "get_contact!/1 returns the contact with given id" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group)
      assert CRM.get_contact!(contact.id) == contact
    end

    test "get_contact!/1 with a non-existent id throws and error" do
      assert_raise Ecto.NoResultsError,
                   ~r/^expected at least one result but got none in query/,
                   fn ->
                     CRM.get_contact!(1312)
                   end
    end

    test "create_contact/2 with valid data creates a contact for a group" do
      {group, _} = group_and_project_fixtures()

      # typical
      assert {:ok, %Contact{} = contact} = CRM.create_contact(group, @valid_attrs.typical)
      assert contact.label == @valid_attrs.typical.label
      assert contact.description == @valid_attrs.typical.description

      # min
      assert {:ok, %Contact{} = contact} = CRM.create_contact(group, @valid_attrs.min)
      assert contact.label == nil
      assert contact.description == nil
    end

    test "create_contact/2 with valid data creates a contact for a project" do
      {_, project} = group_and_project_fixtures()

      # typical
      assert {:ok, %Contact{} = contact} = CRM.create_contact(project, @valid_attrs.typical)
      assert contact.label == @valid_attrs.typical.label
      assert contact.description == @valid_attrs.typical.description

      # min
      assert {:ok, %Contact{} = contact} = CRM.create_contact(project, @valid_attrs.min)
      assert contact.label == nil
      assert contact.description == nil
    end

    test "create_contact/1 with invalid data returns error changeset" do
      {group, project} = group_and_project_fixtures()

      # too long
      assert {:error, %Ecto.Changeset{}} = CRM.create_contact(group, @invalid_attrs.too_long)
      assert {:error, %Ecto.Changeset{}} = CRM.create_contact(project, @invalid_attrs.too_long)
    end

    test "update_contact/2 with valid data updates the contact" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group)

      # typical
      assert {:ok, contact} = CRM.update_contact(contact, @update_attrs.typical)
      assert %Contact{} = contact
      assert contact.label == @update_attrs.typical.label
      assert contact.description == @update_attrs.typical.description
    end

    test "update_contact/2 with invalid data returns error changeset" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group)

      # too long
      assert {:error, %Ecto.Changeset{}} = CRM.update_contact(contact, @invalid_attrs.too_long)
      assert contact == CRM.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group)
      assert {:ok, %Contact{}} = CRM.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> CRM.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group)
      assert %Ecto.Changeset{} = CRM.change_contact(contact)
    end
  end

  # Emails
  # ==============================================================================  
  describe "emails" do
    alias Ferry.CRM.{Contact, Email}

    # Data & Helpers
    # ----------------------------------------------------------
    # These are attributes for the Contact.emails field.
    @valid_emails_attr %{
      typical: %{
        emails: [
          %{email: "email1@example.com"},
          %{email: "email2@example.com"}
        ]
      }
    }

    @update_emails_attr %{
      # 1st and 2nd emails should remain, 3rd email should be added
      addition: %{
        emails: [
          %{email: "email1@example.com"},
          %{email: "email2@example.com"},
          %{email: "new_email@example.com"}
        ]
      },

      # 1st email should remain, 2nd email should be removed
      removal: %{
        emails: [
          %{email: "email1@example.com"}
        ]
      },

      # 1st email should remain, 2nd email should be replaced
      replacement: %{
        emails: [
          %{email: "email1@example.com"},
          %{email: "new_email@example.com"}
        ]
      }
    }

    @invalid_emails_attr %{
      is_nil: %{
        emails: [
          %{email: nil}
        ]
      },
      bad_format: %{
        emails: [
          %{email: "not_an_email"}
        ]
      },
      too_short: %{
        emails: [
          %{email: "a@b."}
        ]
      },
      too_long: %{
        emails: [
          %{
            email:
              "way_too_long_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@example.com"
          }
        ]
      }
    }

    # Tests
    # ----------------------------------------------------------

    test "list_contacts/1 includes emails when returning all contacts for a group" do
      {group1, _} = group_and_project_fixtures()
      {group2, _} = group_and_project_fixtures()

      email3 = %{email: "email3@example.com"}
      email4 = %{email: "email4@example.com"}

      contact1 = contact_fixture(group1, @valid_emails_attr.typical)
      contact2 = contact_fixture(group1, %{emails: [email3]})
      _ = contact_fixture(group2, %{emails: [email4]})

      # all emails are included for the specified group
      contacts = CRM.list_contacts(group1)
      assert contacts == [contact1, contact2]
    end

    test "list_contacts/1 includes emails when returning all contacts for a project" do
      {_, project1} = group_and_project_fixtures()
      {_, project2} = group_and_project_fixtures()

      email3 = %{email: "email3@example.com"}
      email4 = %{email: "email4@example.com"}

      contact1 = contact_fixture(project1, @valid_emails_attr.typical)
      contact2 = contact_fixture(project1, %{emails: [email3]})
      _ = contact_fixture(project2, %{emails: [email4]})

      # all emails are included for the specified group
      contacts = CRM.list_contacts(project1)
      assert contacts == [contact1, contact2]
    end

    test "get_contact!/1 includes emails when returning the contact with given id" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group, @valid_emails_attr.typical)
      assert CRM.get_contact!(contact.id) == contact
    end

    test "create_contact/2 with valid data creates a contact with emails for a group" do
      {group, _} = group_and_project_fixtures()
      contact_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)

      # typical
      assert {:ok, %Contact{} = contact} = CRM.create_contact(group, contact_attrs)
      assert 2 == length(contact.emails)

      assert Enum.at(contact.emails, 0).email ==
               Enum.at(@valid_emails_attr.typical.emails, 0).email

      assert Enum.at(contact.emails, 1).email ==
               Enum.at(@valid_emails_attr.typical.emails, 1).email
    end

    test "create_contact/2 with valid data creates a contact with emails for a project" do
      {_, project} = group_and_project_fixtures()
      contact_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)

      # typical
      assert {:ok, %Contact{} = contact} = CRM.create_contact(project, contact_attrs)
      assert 2 == length(contact.emails)

      assert Enum.at(contact.emails, 0).email ==
               Enum.at(@valid_emails_attr.typical.emails, 0).email

      assert Enum.at(contact.emails, 1).email ==
               Enum.at(@valid_emails_attr.typical.emails, 1).email
    end

    test "create_contact/1 with invalid email data returns error changeset" do
      {group, project} = group_and_project_fixtures()

      # is nil
      contact_with_invalid_email_attrs =
        Enum.into(@invalid_emails_attr.is_nil, @valid_attrs.typical)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_email_attrs)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_email_attrs)

      # bad format
      contact_with_invalid_email_attrs =
        Enum.into(@invalid_emails_attr.bad_format, @valid_attrs.typical)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_email_attrs)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_email_attrs)

      # too short
      contact_with_invalid_email_attrs =
        Enum.into(@invalid_emails_attr.too_short, @valid_attrs.typical)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_email_attrs)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_email_attrs)

      # too long
      contact_with_invalid_email_attrs =
        Enum.into(@invalid_emails_attr.too_long, @valid_attrs.typical)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_email_attrs)

      assert {:error, %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_email_attrs)
    end

    # TODO: The update tests actually removes all of the old Emails and adds new
    #       database entries.  Functionally it doesn't matter- in practice there
    #       might be a small performance hit.  The test should be updated to
    #       reflect what happens in practice:
    #
    #         - Does the frontend return a list of strings? If so, the update
    #           tests accurately reflect the behavior and performance.
    #         - Does the frontend return Email objects for existing / updated
    #           entries?  If so the test should be changed to use email objects.
    #           Note that adding new emails is reflected accurately either way,
    #           since those will just be email strings.
    test "update_contact/2 with valid data adds new emails" do
      {group, _} = group_and_project_fixtures()
      contact_with_email_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_email_attrs)

      # addition
      assert {:ok, contact} = CRM.update_contact(contact, @update_emails_attr.addition)
      assert %Contact{} = contact
      assert 3 == length(contact.emails)

      assert Enum.at(contact.emails, 0).email ==
               Enum.at(@valid_emails_attr.typical.emails, 0).email

      assert Enum.at(contact.emails, 1).email ==
               Enum.at(@valid_emails_attr.typical.emails, 1).email

      assert Enum.at(contact.emails, 2).email ==
               Enum.at(@update_emails_attr.addition.emails, 2).email
    end

    # See note about update_contact/2 email tests above.
    test "update_contact/2 with valid data deletes removed emails" do
      {group, _} = group_and_project_fixtures()
      contact_with_email_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_email_attrs)

      # removal
      assert {:ok, contact} = CRM.update_contact(contact, @update_emails_attr.removal)
      assert %Contact{} = contact
      assert 1 == length(contact.emails)

      assert Enum.at(contact.emails, 0).email ==
               Enum.at(@valid_emails_attr.typical.emails, 0).email
    end

    # See note about update_contact/2 email tests above.
    test "update_contact/2 with valid data replaces changed emails" do
      {group, _} = group_and_project_fixtures()
      contact_with_email_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_email_attrs)

      # addition
      assert {:ok, contact} = CRM.update_contact(contact, @update_emails_attr.replacement)
      assert %Contact{} = contact
      assert 2 == length(contact.emails)

      assert Enum.at(contact.emails, 0).email ==
               Enum.at(@valid_emails_attr.typical.emails, 0).email

      assert Enum.at(contact.emails, 1).email ==
               Enum.at(@update_emails_attr.replacement.emails, 1).email
    end

    test "update_contact/2 with invalid email data returns error changeset" do
      {group, _} = group_and_project_fixtures()
      contact_with_email_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_email_attrs)

      # is nil
      assert {:error, %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_emails_attr.is_nil)

      assert contact == CRM.get_contact!(contact.id)

      # bad format
      assert {:error, %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_emails_attr.bad_format)

      assert contact == CRM.get_contact!(contact.id)

      # too short
      assert {:error, %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_emails_attr.too_short)

      assert contact == CRM.get_contact!(contact.id)

      # too long
      assert {:error, %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_emails_attr.too_long)

      assert contact == CRM.get_contact!(contact.id)
    end

    test "delete_contact/1 also deletes the emails associated with a contact" do
      {group, _} = group_and_project_fixtures()
      contact_with_email_attrs = Enum.into(@valid_emails_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_email_attrs)

      assert {:ok, %Contact{}} = CRM.delete_contact(contact)

      assert [] ==
               Repo.all(
                 from e in Email,
                   where: e.contact_id == ^contact.id
               )
    end
  end

  # Phones
  # ==============================================================================  
  describe "phones" do
    alias Ferry.CRM.{Contact, Phone}

    # Data & Helpers
    # ----------------------------------------------------------
    # These are attributes for the Contact.phones field.
    @valid_phones_attr %{
      typical: %{
        phones: [
          %{country_code: "+44", number: "7445 823 932"},
          %{country_code: "+1", number: "(417) 496-2928"}
        ]
      }
    }

    @update_phones_attr %{
      # 1st and 2nd phones should remain, 3rd phone should be added
      addition: %{
        phones: [
          %{country_code: "+44", number: "7445 823 932"},
          %{country_code: "+1", number: "(417) 496-2928"},
          %{country_code: "+1", number: "229-609-0247"}
        ]
      },

      # 1st phone should remain, 2nd phone should be removed
      removal: %{
        phones: [
          %{country_code: "+44", number: "7445 823 932"}
        ]
      },

      # 1st phone should remain, 2nd phone should be replaced
      replacement: %{
        phones: [
          %{country_code: "+44", number: "7445 823 932"},
          %{country_code: "+1", number: "229-609-0247"}
        ]
      }
    }

    @invalid_phones_attr %{
      is_nil: %{
        phones: [
          %{country_code: nil, number: nil}
        ]
      },
      too_short: %{
        phones: [
          %{country_code: "", number: ""}
        ]
      },
      too_long: %{
        phones: [
          %{
            country_code:
              "way too long xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            number:
              "way too long xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
          }
        ]
      }
    }

    # Tests
    # ----------------------------------------------------------

    test "list_contacts/1 includes phones when returning all contacts for a group" do
      {group1, _} = group_and_project_fixtures()
      {group2, _} = group_and_project_fixtures()

      phone3 = %{country_code: "+30", number: "123 456 7890"}
      phone4 = %{country_code: "+33", number: "98 76 54 32 11"}

      contact1 = contact_fixture(group1, @valid_phones_attr.typical)
      contact2 = contact_fixture(group1, %{phones: [phone3]})
      _ = contact_fixture(group2, %{phones: [phone4]})

      # all phones are included for the specified group
      contacts = CRM.list_contacts(group1)
      assert contacts == [contact1, contact2]
    end

    test "list_contacts/1 includes phones when returning all contacts for a project" do
      {_, project1} = group_and_project_fixtures()
      {_, project2} = group_and_project_fixtures()

      phone3 = %{country_code: "+30", number: "123 456 7890"}
      phone4 = %{country_code: "+33", number: "98 76 54 32 11"}

      contact1 = contact_fixture(project1, @valid_phones_attr.typical)
      contact2 = contact_fixture(project1, %{phones: [phone3]})
      _ = contact_fixture(project2, %{phones: [phone4]})

      # all phones are included for the specified group
      contacts = CRM.list_contacts(project1)
      assert contacts == [contact1, contact2]
    end

    test "get_contact!/1 includes phones when returning the contact with given id" do
      {group, _} = group_and_project_fixtures()
      contact = contact_fixture(group, @valid_phones_attr.typical)
      assert CRM.get_contact!(contact.id) == contact
    end

    test "create_contact/2 with valid data creates a contact with phones for a group" do
      {group, _} = group_and_project_fixtures()
      contact_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)

      # typical
      assert {:ok, %Contact{} = contact} = CRM.create_contact(group, contact_attrs)
      assert 2 == length(contact.phones)

      assert Enum.at(contact.phones, 0).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 0).country_code

      assert Enum.at(contact.phones, 0).number ==
               Enum.at(@valid_phones_attr.typical.phones, 0).number

      assert Enum.at(contact.phones, 1).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 1).country_code

      assert Enum.at(contact.phones, 1).number ==
               Enum.at(@valid_phones_attr.typical.phones, 1).number
    end

    test "create_contact/2 with valid data creates a contact with phones for a project" do
      {_, project} = group_and_project_fixtures()
      contact_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)

      # typical
      assert {:ok, %Contact{} = contact} = CRM.create_contact(project, contact_attrs)
      assert 2 == length(contact.phones)

      assert Enum.at(contact.phones, 0).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 0).country_code

      assert Enum.at(contact.phones, 1).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 1).country_code
    end

    test "create_contact/1 with invalid phone data returns error changeset" do
      {group, project} = group_and_project_fixtures()

      # is nil
      contact_with_invalid_phone_attrs =
        Enum.into(@invalid_phones_attr.is_nil, @valid_attrs.typical)

      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_phone_attrs)

      assert 2 == Enum.at(changeset.changes.phones, 0).errors |> length

      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_phone_attrs)

      assert 2 == Enum.at(changeset.changes.phones, 0).errors |> length

      # too short
      contact_with_invalid_phone_attrs =
        Enum.into(@invalid_phones_attr.too_short, @valid_attrs.typical)

      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_phone_attrs)

      assert 2 == Enum.at(changeset.changes.phones, 0).errors |> length

      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_phone_attrs)

      assert 2 == Enum.at(changeset.changes.phones, 0).errors |> length

      # too long
      contact_with_invalid_phone_attrs =
        Enum.into(@invalid_phones_attr.too_long, @valid_attrs.typical)

      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.create_contact(group, contact_with_invalid_phone_attrs)

      assert 2 == Enum.at(changeset.changes.phones, 0).errors |> length

      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.create_contact(project, contact_with_invalid_phone_attrs)

      assert 2 == Enum.at(changeset.changes.phones, 0).errors |> length
    end

    # TODO: The update tests actually removes all of the old Phones and adds new
    #       database entries.  Functionally it doesn't matter- in practice there
    #       might be a small performance hit.  The test should be updated to
    #       reflect what happens in practice:
    #
    #         - Does the frontend return a list of strings? If so, the update
    #           tests accurately reflect the behavior and performance.
    #         - Does the frontend return Phone objects for existing / updated
    #           entries?  If so the test should be changed to use phone objects.
    #           Note that adding new phones is reflected accurately either way,
    #           since those will just be phone strings.
    test "update_contact/2 with valid data adds new phones" do
      {group, _} = group_and_project_fixtures()
      contact_with_phone_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_phone_attrs)

      # addition
      assert {:ok, contact} = CRM.update_contact(contact, @update_phones_attr.addition)
      assert %Contact{} = contact
      assert 3 == length(contact.phones)

      assert Enum.at(contact.phones, 0).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 0).country_code

      assert Enum.at(contact.phones, 0).number ==
               Enum.at(@valid_phones_attr.typical.phones, 0).number

      assert Enum.at(contact.phones, 1).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 1).country_code

      assert Enum.at(contact.phones, 1).number ==
               Enum.at(@valid_phones_attr.typical.phones, 1).number

      assert Enum.at(contact.phones, 2).country_code ==
               Enum.at(@update_phones_attr.addition.phones, 2).country_code

      assert Enum.at(contact.phones, 2).number ==
               Enum.at(@update_phones_attr.addition.phones, 2).number
    end

    # See note about update_contact/2 phone tests above.
    test "update_contact/2 with valid data deletes removed phones" do
      {group, _} = group_and_project_fixtures()
      contact_with_phone_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_phone_attrs)

      # removal
      assert {:ok, contact} = CRM.update_contact(contact, @update_phones_attr.removal)
      assert %Contact{} = contact
      assert 1 == length(contact.phones)

      assert Enum.at(contact.phones, 0).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 0).country_code

      assert Enum.at(contact.phones, 0).number ==
               Enum.at(@valid_phones_attr.typical.phones, 0).number
    end

    # See note about update_contact/2 phone tests above.
    test "update_contact/2 with valid data replaces changed phones" do
      {group, _} = group_and_project_fixtures()
      contact_with_phone_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_phone_attrs)

      # addition
      assert {:ok, contact} = CRM.update_contact(contact, @update_phones_attr.replacement)
      assert %Contact{} = contact
      assert 2 == length(contact.phones)

      assert Enum.at(contact.phones, 0).country_code ==
               Enum.at(@valid_phones_attr.typical.phones, 0).country_code

      assert Enum.at(contact.phones, 0).number ==
               Enum.at(@valid_phones_attr.typical.phones, 0).number

      assert Enum.at(contact.phones, 1).country_code ==
               Enum.at(@update_phones_attr.replacement.phones, 1).country_code

      assert Enum.at(contact.phones, 1).number ==
               Enum.at(@update_phones_attr.replacement.phones, 1).number
    end

    test "update_contact/2 with invalid phone data returns error changeset" do
      {group, _} = group_and_project_fixtures()
      contact_with_phone_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_phone_attrs)

      # is nil
      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_phones_attr.is_nil)

      assert 2 == Enum.at(changeset.changes.phones, 2).errors |> length
      assert contact == CRM.get_contact!(contact.id)

      # too short
      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_phones_attr.too_short)

      assert 2 == Enum.at(changeset.changes.phones, 2).errors |> length
      assert contact == CRM.get_contact!(contact.id)

      # too long
      assert {:error, changeset = %Ecto.Changeset{}} =
               CRM.update_contact(contact, @invalid_phones_attr.too_long)

      assert 2 == Enum.at(changeset.changes.phones, 2).errors |> length
      assert contact == CRM.get_contact!(contact.id)
    end

    test "delete_contact/1 also deletes the phones associated with a contact" do
      {group, _} = group_and_project_fixtures()
      contact_with_phone_attrs = Enum.into(@valid_phones_attr.typical, @valid_attrs.typical)
      contact = contact_fixture(group, contact_with_phone_attrs)

      assert {:ok, %Contact{}} = CRM.delete_contact(contact)

      assert [] ==
               Repo.all(
                 from p in Phone,
                   where: p.contact_id == ^contact.id
               )
    end
  end
end
