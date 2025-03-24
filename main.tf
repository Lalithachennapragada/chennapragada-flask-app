provider "google" {
  project = "supple-gearbox-447219-d0"  # Replace with your GCP Project ID
  region  = "us-central1"
}

# Create a VPC
resource "google_compute_network" "vpc" {
  name = "chennapragada-vpc"
}

# Create a Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "chennapragada-subnet"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
}

# Create a Firewall Rule to allow traffic on port 5000
resource "google_compute_firewall" "allow_flask" {
  name    = "chennapragada-allow-flask"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a Compute Engine Instance
resource "google_compute_instance" "flask_instance" {
  name         = "chennapragada-flask"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"  # Container-Optimized OS
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}  # Assigns a public IP
  }

  metadata = {
    google-logging-enabled = "true"
  }

  metadata_startup_script = <<-EOT
    docker run -d -p 5000:5000 gcr.io/supple-gearbox-447219-d0/chennapragada-flask-app
  EOT
}

output "instance_ip" {
  value = google_compute_instance.flask_instance.network_interface.0.access_config.0.nat_ip
}
