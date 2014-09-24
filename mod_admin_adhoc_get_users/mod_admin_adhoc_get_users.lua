-- Copyright (C) 2009-2011 Florian Zeitz
--
-- This file is MIT/X11 licensed. Please see the
-- COPYING file in the source package for more information.
--

local _G = _G;

local prosody = _G.prosody;
local hosts = prosody.hosts;
local t_concat = table.concat;

local module_host = module:get_host();

local usermanager_get_users = require "core.usermanager". users;

local dataforms_new = require "util.dataforms".new;
local adhoc_simple = require "util.adhoc".new_simple_form;

module:depends("adhoc");
local adhoc_new = module:require "adhoc".new;

local function generate_error_message(errors)
	local errmsg = {};
	for name, err in pairs(errors) do
		errmsg[#errmsg + 1] = name .. ": " .. err;
	end
	return { status = "completed", error = { message = t_concat(errmsg, "\n") } };
end

-- Getting a list of all users
local get_all_users_layout = dataforms_new{
	title = "Getting List of All Users";
	instructions = "How many users should be returned at most?";

	{ name = "FORM_TYPE", type = "hidden", value = "http://jabber.org/protocol/admin" };
	{ name = "max_items", type = "list-single", label = "Maximum number of users",
		value = { "25", "50", "75", "100", "150", "200", "all" } };
};

local get_all_users_result_layout = dataforms_new{
	{ name = "FORM_TYPE", type = "hidden", value = "http://jabber.org/protocol/admin" };
	{ name = "userjids", type = "text-multi", label = "The list of users" };
};

local get_all_users_command_handler = adhoc_simple(get_all_users_layout, function(fields, err)
	if err then
		return generate_error_message(err);
	end

	local max_items = nil
	if fields.max_items ~= "all" then
		max_items = tonumber(fields.max_items);
	end
	local count = 0;
	local users = {};
	for username, user in usermanager_get_users(module_host) do
		if (max_items ~= nil) and (count >= max_items) then
			break;
		end
		users[#users+1] = username.."@"..module_host;
		count = count + 1;
	end
	return { status = "completed", result = {layout = get_all_users_result_layout, values = {userjids=t_concat(users, "\n")}} };
end);

local get_all_users_desc = adhoc_new("Get List of All Users", "http://jabber.org/protocol/admin#get-user-list", get_all_users_command_handler, "admin");

module:provides("adhoc", get_all_users_desc);
