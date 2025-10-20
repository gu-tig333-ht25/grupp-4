## Introduction
We four as a project for a course on flutter programming decided to develop a booktracking app. We are all avid readers and felt like the biggest current booktracking apps lacked certain specificity in their filtering mechanisms, had very broad and vague recommensations and well as quite a boring colorscheme. So we decided to fix that!

## Decisions 

Our demographic is people who want to get back into reading between 18-45. This makes it so that we cannot guarantee the appropriotness of the books for minors, as well as no design made with the elderly or visually impared in mind. 

We decided on 5 different views, one for login, one for home page, one for profile page, one for search page, and one page for book information. We decided early on on a "dark acacdemia" colorscheme with mostly green colors. We also decided that the home page would only have lists of recommendations based on what books you've liked previously. In your profile you could save books into different lists (like "want to read"), and in the search page you could either search for a title or author and get tags for that book, or search for tags you find interesting and get books that contain those.

We used Moscow to prioritise functions and decided that the MVP was those five screens, a search function, a couple of tags, information about the book, some sort of recommendation on the home page, a login, and a way to save books in one of two lists.

Functions we decided not to include as the MVP:
• Adding subtitles like "the sorcerers stone" after "Harry Potter"
• A customisable colorscheme for each profile
• Sorting on genres in the home page (since our API doesn't contain that information) to authors
• Making filters disappear when having searched for a title
• Make all containers uniform in design
• Having chosen bottom bar page a different color to show selected one
• Having a logo

