#!/usr/bin/env bash

(
set -e
basedir="$(cd "$1" && pwd -P)"
workdir="$basedir/work"
paperbasedir="$basedir/work/Paper"
paperworkdir="$basedir/work/Paper/work"

if [ "$2" == "--setup" ] || [ "$3" == "--setup" ] || [ "$4" == "--setup" ]; then
	echo "[Akarin] Setup Paper.."
	(
		if [ "$2" == "--remote" ] || [ "$3" == "--remote" ] || [ "$4" == "--remote" ]; then
			cd "$paperworkdir"
			if [ -d "Minecraft" ]; then
				rm Minecraft/ -r
			fi
			git clone https://github.com/Akarin-project/Minecraft.git
		fi

		#cd "$paperbasedir"
		#./paper patch
	)
fi

echo "[Akarin] Ready to build"
(
	cd "$paperbasedir"
	echo "[Akarin] Touch sources.."
	
	cd "$paperbasedir"
	if [ "$2" == "--fast" ] || [ "$3" == "--fast" ] || [ "$4" == "--fast" ]; then
		echo "[Akarin] Test and repatch has been skipped"
		\cp -rf "$basedir/api/src/main" "$paperbasedir/Paper-API/src/"
		\cp -rf "$basedir/api/pom.xml" "$paperbasedir/Paper-API/"
		\cp -rf "$basedir/src" "$paperbasedir/Paper-Server/"
		\cp -rf "$basedir/pom.xml" "$paperbasedir/Paper-Server/"
		mvn clean install -Dmaven.test.skip=true
	else
		rm -rf Paper-API/src
		rm -rf Paper-Server/src
		./paper patch
		\cp -rf "$basedir/api/src/main" "$paperbasedir/Paper-API/src/"
		\cp -rf "$basedir/api/pom.xml" "$paperbasedir/Paper-API/"
		\cp -rf "$basedir/src" "$paperbasedir/Paper-Server/"
		\cp -rf "$basedir/pom.xml" "$paperbasedir/Paper-Server/"
		mvn clean install -Dmaven.test.skip=true
	fi
	
	minecraftversion=$(cat "$paperworkdir/BuildData/info.json" | grep minecraftVersion | cut -d '"' -f 4)
	rawjar="$paperbasedir/Paper-Server/target/akarin-$minecraftversion.jar"
	\cp -rf "$rawjar" "$basedir/akarin-$minecraftversion.jar"
	rawapi="$paperbasedir/Paper-API/target/akarin-api-1.14.4-R0.1-SNAPSHOT.jar"
	\cp -rf "$rawapi" "$basedir/akarin-api-1.14.4-R0.1-SNAPSHOT.jar"
	
	echo ""
	echo "[Akarin] Build successful"
	echo "[Akarin] Migrated the final jar to $basedir/"
)

)
