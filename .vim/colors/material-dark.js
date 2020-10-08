module.exports.colors = {
    // A color set can have both light and dark variants, but is only required
    // to have one.
    dark: {
        // Colors can be defined in any valid CSS format.

        // accent0-7 should be the main accent colors of your theme. See the table
        // in the "Color mappings" section for how the colors will be used in your
        // new themes.
        accent0: "#F07178", // Error, VCS Deletion
        accent1: "#F78C6C", // Syntax
        accent2: "#FFCB6B", // Warning, VCS modification
        accent3: "#C3E88D", // Success, VCS addition
        accent4: "#89DDFF", // Syntax
        accent5: "#89DDFF", // Syntax
        accent6: "#89DDFF", // Syntax, caret/cursor
        accent7: "#C792EA", // Syntax, special

        // shade0-7 should be shades of the same hue, with shade0 being the
        // background and shade7 being the foreground. If you omit the
        // intermediate shades (1 through 6), they will be calculated automatically
        // for you.
        shade0: "#212121",
        shade7: "#EEFFFF",

    },
}
