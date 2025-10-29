#!/bin/bash

user="jurakovic"
json="../jurakovic/data.json"
readme="README.md"

cat << EOF > $readme

<p align="center">
	<a href="https://github.com/$user">
		<img align="center" src="https://images.weserv.nl/?url=avatars.githubusercontent.com/u/17744091?v=4&h=260&w=260&fit=cover&mask=circle&maxage=1d" alt="$user" class="responsive-image" />
	</a>
</p>
<br>

#### Technologies / Tools / Skills

<p align="center">
EOF

tech=$(jq -r '.tech[] | "	<img alt=\"tech\" src=\"\(.)\" />"' "$json")
echo "$tech" >> $readme

cat << EOF >> $readme
</p>

#### Some Projects

EOF

projects=$(jq -r '.projects[]' "$json")

jq -c '.projects[]' "$json" | while read i; do
  repo=$(echo "$i" | jq -r '.repo')
  icon=$(echo "$i" | jq -r '.icon')
  pages=$(echo "$i" | jq -r '.pages')
  mapfile -t descr < <(echo "$i" | jq -r '.description[]')
  mapfile -t pagesRepo < <(echo "$i" | jq -r '.pagesRepo[]?')

  if [ "$pages" == "true" ]
  then
    echo "- $icon [$repo](https://$user.github.io/$repo/)" >> $readme
  else
	echo "- $icon $repo" >> $readme
  fi

  for line in "${descr[@]}"; do
    echo "	- $line" >> $readme
  done

  echo "	- <https://github.com/$user/$repo>" >> $readme

  for line in "${pagesRepo[@]}"; do
    echo "	- $line" >> $readme
  done
done

cat << EOF >> $readme

#### Language Stats

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github-readme-stats.vercel.app/api/top-langs/?username=jurakovic&layout=compact&hide=java&theme=github_dark_dimmed">
  <source media="(prefers-color-scheme: light)" srcset="https://github-readme-stats.vercel.app/api/top-langs/?username=jurakovic&layout=compact&hide=java">
  <img src="https://github-readme-stats.vercel.app/api/top-langs/?username=jurakovic&layout=compact&hide=java&theme=github_dark_dimmed">
</picture>
EOF

# fix line ending
dos2unix -q "$readme"

echo "Done"
