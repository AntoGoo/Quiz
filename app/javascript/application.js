// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log("✅ Le fichier application.js est bien chargé !");
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;
import "@hotwired/turbo-rails"
import "controllers"
import { Application } from "@hotwired/stimulus";
const application = Application.start();
window.Stimulus = application;
import { Turbo } from "@hotwired/turbo-rails"
import Rails from "@rails/ujs";
Rails.start();
console.log("Turbo chargé :", Turbo)