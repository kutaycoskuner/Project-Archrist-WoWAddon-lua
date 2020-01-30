local options = { 
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message to be displayed when you get home.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
        },
    },
}
