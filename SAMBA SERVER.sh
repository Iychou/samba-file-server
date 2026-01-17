# ================================
# PROJET : SERVEUR SAMBA (NIVEAU INTERMÉDIAIRE)
# ================================

# Mise à jour du système
sudo apt update

# Installation de Samba
sudo apt install samba -y

# Création des groupes
sudo groupadd samba_users
sudo groupadd samba_admins

# Création des utilisateurs
sudo useradd -m -s /bin/bash user1
sudo useradd -m -s /bin/bash user2
sudo useradd -m -s /bin/bash admin1

# Ajout des utilisateurs aux groupes
sudo usermod -aG samba_users user1
sudo usermod -aG samba_users user2
sudo usermod -aG samba_admins admin1

# Définition des mots de passe Linux
sudo passwd user1
sudo passwd user2
sudo passwd admin1

# Ajout des utilisateurs Samba
sudo smbpasswd -a user1
sudo smbpasswd -a user2
sudo smbpasswd -a admin1

# Création des répertoires partagés
sudo mkdir -p /srv/samba/public
sudo mkdir -p /srv/samba/private
sudo mkdir -p /srv/samba/admin

# Attribution des groupes
sudo chown -R root:samba_users /srv/samba/public
sudo chown -R root:samba_users /srv/samba/private
sudo chown -R root:samba_admins /srv/samba/admin

# Permissions avancées + sticky bit
sudo chmod 2775 /srv/samba/public
sudo chmod 2770 /srv/samba/private
sudo chmod 2770 /srv/samba/admin

# Sauvegarde de la configuration Samba
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Édition de la configuration Samba
sudo nano /etc/samba/smb.conf

# --------- À AJOUTER À LA FIN DU FICHIER ---------
# [Public]
#    path = /srv/samba/public
#    browsable = yes
#    writable = yes
#    guest ok = yes
#    read only = no
#
# [Private]
#    path = /srv/samba/private
#    browsable = yes
#    writable = yes
#    valid users = @samba_users
#    read only = no
#
# [Admin]
#    path = /srv/samba/admin
#    browsable = yes
#    writable = yes
#    valid users = @samba_admins
#    read only = no
# ------------------------------------------------

# Vérification de la configuration
testparm

# Redémarrage et activation des services
sudo systemctl restart smbd nmbd
sudo systemctl enable smbd nmbd

# Configuration du firewall
sudo ufw allow samba
sudo ufw reload

# Tests locaux
smbclient -L localhost -U user1
smbclient //localhost/Private -U user1

# Audit des connexions Samba
sudo smbstatus

# Consultation des logs
sudo tail -f /var/log/samba/log.smbd
