# Re-exports all database functions so existing imports like
# `from app.database import insert_game` continue to work unchanged.

from app.database.users.users import (
    users,
    insert_user,
    get_user_by_username,
    get_all_users,
    delete_user_by_username,
    update_user_by_username,
    add_user_to_group,
    remove_user_from_group,
    get_group_members,
    add_user_achievement,
    remove_user_achievement,
    get_user_achievements,
)

from app.database.games.games import (
    insert_game,
    get_game_by_name,
    get_game_by_id,
    get_all_game,
    update_game_by_id,
    delete_game_by_id,
)

from app.database.games.achievements import (
    insert_achievement,
    get_achievement_by_id,
    get_all_achievements,
    get_achievements_by_game,
    update_achievement_by_id,
    delete_achievement_by_id,
)

from app.database.games.forums.forums import (
    insert_forum,
    get_forum_by_id,
    get_forums_by_game,
    delete_forum_by_id,
)

from app.database.games.forums.guides import (
    insert_guide,
    get_guide_by_id,
    delete_guide_by_id,
    get_guides_by_forum,
)

from app.database.games.forums.wiki import (
    insert_wiki,
    get_wiki_by_id,
    get_all_wiki,
    get_wikis_by_forum,
    update_wiki_by_id,
    delete_wiki_by_id,
)

from app.database.games.forums.tier_list import (
    insert_tier_list,
    get_tier_list_by_id,
    get_all_tier_list,
    get_tier_lists_by_forum,
    update_tier_list_by_id,
    delete_tier_list_by_id,
)

from app.database.games.forums.groups import (
    insert_group,
    get_group_by_id,
    get_all_groups,
    get_groups_by_forum,
    update_group_by_id,
    delete_group_by_id,
)

from app.database.games.forums.builds import (
    insert_build,
    get_build_by_id,
    get_all_builds,
    get_builds_by_forum,
    update_build,
    delete_build,
)

from app.database.games.forums.discussion import (
    insert_discussion,
    get_discussion_by_id,
    get_all_discussions,
    get_discussions_by_forum,
    update_discussion,
    delete_discussion,
)

from app.database.messages.messages import (
    insert_message_instance,
    get_message_instance_by_id,
    get_all_messages_instance,
    delete_message_instance,
    insert_chat,
    get_chat_by_id,
    get_all_chats,
    get_chats_by_message_instance,
    delete_chat,
)

__all__ = [
    # users
    "users",
    "insert_user", "get_user_by_username", "get_all_users",
    "delete_user_by_username", "update_user_by_username",
    "add_user_to_group", "remove_user_from_group", "get_group_members",
    "add_user_achievement", "remove_user_achievement", "get_user_achievements",
    # games
    "insert_game", "get_game_by_name", "get_game_by_id",
    "get_all_game", "update_game_by_id", "delete_game_by_id",
    # achievements
    "insert_achievement", "get_achievement_by_id", "get_all_achievements",
    "get_achievements_by_game", "update_achievement_by_id", "delete_achievement_by_id",
    # forums
    "insert_forum", "get_forum_by_id", "get_forums_by_game", "delete_forum_by_id",
    # guides
    "insert_guide", "get_guide_by_id", "delete_guide_by_id", "get_guides_by_forum",
    # wiki
    "insert_wiki", "get_wiki_by_id", "get_all_wiki", "get_wikis_by_forum",
    "update_wiki_by_id", "delete_wiki_by_id",
    # tier_list
    "insert_tier_list", "get_tier_list_by_id", "get_all_tier_list",
    "get_tier_lists_by_forum", "update_tier_list_by_id", "delete_tier_list_by_id",
    # groups
    "insert_group", "get_group_by_id", "get_all_groups", "get_groups_by_forum",
    "update_group_by_id", "delete_group_by_id",
    # builds
    "insert_build", "get_build_by_id", "get_all_builds", "get_builds_by_forum",
    "update_build", "delete_build",
    # discussion
    "insert_discussion", "get_discussion_by_id", "get_all_discussions",
    "get_discussions_by_forum", "update_discussion", "delete_discussion",
    # messages_instance + chat
    "insert_message_instance", "get_message_instance_by_id",
    "get_all_messages_instance", "delete_message_instance",
    "insert_chat", "get_chat_by_id", "get_all_chats",
    "get_chats_by_message_instance", "delete_chat",
]
