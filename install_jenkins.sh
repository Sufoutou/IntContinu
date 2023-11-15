#!/bin/bash

# Mise à jour des packages
sudo apt update

# Installation de Java (si ce n'est pas déjà installé)
sudo apt install -y default-jre

# Ajout du référentiel Jenkins et de la clé GPG
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

# Mise à jour des packages après l'ajout du référentiel
sudo apt update

# Installation de Jenkins
sudo apt install -y jenkins

# Démarrage du service Jenkins
sudo systemctl start jenkins

# Activation du démarrage automatique au démarrage du système
sudo systemctl enable jenkins

# Attente que Jenkins démarre complètement (ajustez selon vos besoins)
sleep 30

# Récupération du mot de passe administrateur généré par Jenkins
admin_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# Chemin du fichier de configuration JCasC
casc_file="/var/lib/jenkins/casc_configs/jenkins.yaml"

# Création du fichier de configuration JCasC
sudo mkdir -p /var/lib/jenkins/casc_configs
sudo chown -R jenkins:jenkins /var/lib/jenkins/casc_configs

cat <<EOF | sudo tee $casc_file
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "admin"
          password: "$admin_password"
  authorizationStrategy: loggedInUsersCanDoAnything
EOF

# Redémarrage de Jenkins pour appliquer la configuration
sudo systemctl restart jenkins
