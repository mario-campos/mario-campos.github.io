cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<article data-sblg-article="1">
  <header>
    <h1>$($LOWDOWN -X title "$1")</h1>
    <address>$($LOWDOWN -X author "$1")</address>
    <time datetime="$($LOWDOWN -X date "$1")">$($LOWDOWN -X date "$1")</time>
  </header>
  <aside>$($LOWDOWN -X summary "$1")</aside>
  $($LOWDOWN "$1")
</article>
EOF
