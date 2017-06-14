# WhatsUp #

WhatsUp is a set of Haskell scripts that tell you what's up with your WhatsApp chats.

## Why ##

Why not?

## What statistics can we see? ##

Currently, following things can be reported. Ideas welcome.

- **Word Count Distribution:** Distribution of message lengths. For example, there are two lines with 3 words each and 30 lines with 5 words each. Yup, this needs a better name.
- **Word Frequency:** Tells how many times each word was used by the person.
- **Average Line Length:** Reports average line length (in number of words per line) for each person.
- **Lines Per Message:** Tells average number of lines per message for each person. We need this because some people think that writing WhatsApp chat is the best tool to write 10 point synopsis. Single line messages are excluded to since they heavily skew the average.
- **Line Count:** Reports number of lines texted by each person.
- **Word Count:** Reports number of words used by each person (duh!).
- **Unique Word Count:** Reports number of unique words used by each person. If you get a high score on this one, you're either a vocabulary nerd or really bad at spelling.

## What do I do with these statistics? ##
I like to create pretty visualizations using Tableau. [Here](https://public.tableau.com/views/HeAndShe/HisWordCloud?:embed=y&:display_count=yes) is one I created using word frequency.

<div class='tableauPlaceholder' id='viz1497461333125' style='position: relative'><noscript><a href='https://public.tableau.com/views/HeAndShe/HisWordCloud?:embed=y&:display_count=yes'><img alt=' ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;He&#47;HeAndShe&#47;HisWordCloud&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='site_root' value='' /><param name='name' value='HeAndShe&#47;HisWordCloud' /><param name='tabs' value='yes' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;He&#47;HeAndShe&#47;HisWordCloud&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /></object></div>
