add_repo_firefox() {
	echo "Adding firefox repo..."
	# Create directory for APT repository keys if it doesn't exist
	sudo install -d -m 0755 /etc/apt/keyrings

	# Import Mozilla APT repository signing key
	wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

	# Initialize GPG keyring
	gpg --list-keys

	# Verify the key fingerprint
	gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | \
		awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

	# Add Mozilla APT repository to sources list
	echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

	# Configure APT to prioritize packages from the Mozilla repository
	echo '
	Package: *
	Pin: origin packages.mozilla.org
	Pin-Priority: 1000
	' | sudo tee /etc/apt/preferences.d/mozilla

	echo "firefox repo added"
}