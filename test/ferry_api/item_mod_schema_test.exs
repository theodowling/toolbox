defmodule Ferry.ItemModSchemaTest do
  use FerryWeb.ConnCase, async: true
  import Ferry.ApiClient.{Category, Item, Mod}

  test "add/remove a mod to/from an existing item", %{conn: conn} do
    insert(:user)
    |> mock_sign_in

    # create the category
    %{
      "data" => %{
        "createCategory" => %{
          "successful" => true,
          "messages" => [],
          "result" => %{
            "id" => clothing
          }
        }
      }
    } = create_category(conn, %{name: "clothing"})

    # create the item
    %{
      "data" => %{
        "createItem" => %{
          "successful" => true,
          "messages" => [],
          "result" => %{
            "id" => t_shirt_id
          }
        }
      }
    } =
      create_item(conn, %{
        category: clothing,
        name: "t-shirt"
      })

    # create the mod
    %{
      "data" => %{
        "createMod" => %{
          "successful" => true,
          "result" => %{
            "id" => sizes_id
          }
        }
      }
    } = create_mod(conn, %{name: "sizes", description: "Sizes", type: "select"})

    # link the mod to the item
    %{
      "data" => %{
        "addModToItem" => %{
          "successful" => true
        }
      }
    } =
      add_mod_to_item(conn, %{
        item: t_shirt_id,
        mod: sizes_id
      })

    # Get the item and all its mods
    %{
      "data" => %{
        "item" => %{
          "id" => ^t_shirt_id,
          "mods" => [
            mod
          ]
        }
      }
    } = get_item_with_mods(conn, t_shirt_id)

    assert sizes_id == mod["id"]

    # Try to add the same mod again
    %{
      "data" => %{
        "addModToItem" => %{
          "successful" => false,
          "messages" => [
            error
          ]
        }
      }
    } =
      add_mod_to_item(conn, %{
        item: t_shirt_id,
        mod: sizes_id
      })

    assert "already exists" == error["message"]

    # unlink the mod from the item
    %{
      "data" => %{
        "removeModFromItem" => %{
          "successful" => true
        }
      }
    } =
      remove_mod_from_item(conn, %{
        item: t_shirt_id,
        mod: sizes_id
      })

    # Get the item and all its mods
    %{
      "data" => %{
        "item" => %{
          "id" => ^t_shirt_id,
          "mods" => []
        }
      }
    } = get_item_with_mods(conn, t_shirt_id)
  end
end
