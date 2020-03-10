#!/bin/sh

repo="http://nesux.self.com"
groupId=$1
artifactId=$2
version=$3

# optional
type=$4

if [[ $type == "" ]]; then
  type="jar"
fi

groupIdUrl="${groupId//.//}"
filename="${artifactId}-${version}.${type}"

if [[ ${version} == *"SNAPSHOT"* ]]; then repo_type="snapshots"; else repo_type="releases"; fi

if [[ $repo_type == "releases" ]]
 then
   wget --no-check-certificate "${repo}/repository/maven-releases/${groupIdUrl}/${artifactId}/${version}/${artifactId}-${version}.${type}" -O ${filename} -k
 else
   versionTimestamped=$(wget -q -O- --no-check-certificate "${repo}/repository/maven-snapshots/${groupIdUrl}/${artifactId}/${version}/maven-metadata.xml" | grep -m 1 \<value\> | sed -e 's/<value>\(.*\)<\/value>/\1/' | sed -e 's/ //g')

   wget --no-check-certificate "${repo}/repository/maven-snapshots/${groupIdUrl}/${artifactId}/${version}/${artifactId}-${versionTimestamped}${classifier}.${type}" -O ${filename}
 fi
