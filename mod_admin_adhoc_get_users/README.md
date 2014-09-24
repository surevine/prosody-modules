mod_admin_adhoc_get_users
===========================

Ad-hoc command that allows you to retrieve a list of users on a server.

# Configuration

There is no special configuration for this module. After enabling it Prosody will automatically offer the command to server admins via the "Execute command" option in their client.

Note: In Prosody 0.8.x you also need to enable the 'adhoc' module.

# Client support

Clients known to support ad-hoc commands include: Psi, Gajim, Pidgin, tkabber and probably others.

# Example

    modules_enabled = {
        ... other modules here ...
        "adhoc"; -- Also required in Prosody 0.8.x
        "admin_adhoc_get_users";
        ... maybe other modules here ...