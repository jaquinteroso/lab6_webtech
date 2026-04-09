# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts "Cleaning database..."
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Vet.destroy_all
Owner.destroy_all

puts "Creating vets..."
2.times do
  Vet.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.cell_phone,
      specialization: ["General Practice", "Surgery", "Dermatology", "Oncology"].sample
  )
end

puts "Creating owners and pets..."
owners = []
3.times do
  owner = Owner.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.cell_phone,
    address: Faker::Address.full_address
  )
  owners << owner
end

species_options = ["Dog", "Cat", "Rabbit", "Hamster"]
5.times do
  Pet.create!(
    owner: owners.sample,
    name: Faker::Creature::Dog.name,
    species: species_options.sample,
    breed: Faker::Creature::Dog.breed,
    date_of_birth: Faker::Date.between(from: 10.years.ago, to: Date.today),
    weight: rand(1.5..40.0).round(2)
  )
end

puts "Creating appointments..."
5.times do |i|
  Appointment.create!(
    pet: Pet.all.sample,
    vet: Vet.all.sample,
    date: Faker::Time.between(from: DateTime.now - 1.month, to: DateTime.now + 1.month),
    reason: ["Annual Checkup", "Vaccination", "Injury", "General Consultation"].sample,
    status: [0, 1, 2].sample # 0: scheduled, 1: in progress, 2: completed, 3: cancelled
  )
end

puts "Creating treatments..."
# Buscamos citas que no estén canceladas (status != 3)
valid_appointments = Appointment.where.not(status: 3).limit(5)

valid_appointments.each do |appointment|
  appointment.treatments.create!(
    name: ["Antibiotics", "Pain Relief", "Wound Cleaning", "Vitamin Boost"].sample,
    medication: Faker::Science.element, # Nombre ficticio de medicina
    dosage: "#{rand(1..10)}ml every #{rand(4..12)} hours",
    notes: Faker::Lorem.paragraph(sentence_count: 2),
    administered_at: appointment.date + 1.hour
  )
end

puts "Seed finished! Created: #{Owner.count} owners, #{Pet.count} pets, #{Vet.count} vets, #{Appointment.count} appointments, and #{Treatment.count} treatments."
