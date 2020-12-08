cat <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<article data-sblg-article="1">
  <header>
    <h1>$($LOWDOWN -X title "$1")</h1>
    <address>$($LOWDOWN -X author "$1")</address>
    <time>$($LOWDOWN -X date "$1")</time>
    <aside>$($LOWDOWN -X summary "$1")</aside>
  </header>
  $($LOWDOWN "$1")
</article>
EOF
