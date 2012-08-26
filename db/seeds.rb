# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Selection.create({url: "http://www.marmiton.org/recettes/selection_citadin.aspx", description: "Citadin", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_etudiant.aspx", description: "Etudiant", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_dejeuner_au_bureau.aspx", description: "Déjeuner au bureau", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_cuisine_rapide.aspx", description: "Cuisine rapide", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_micro_ondes.aspx", description: "Micro onde", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_sans_four.aspx", description: "Sans four", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_cuisine_au_verre.aspx", description: "Cuisine au verre", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_pique_nique.aspx", description: "Pique nique", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_flemme.aspx", description: "Flemme", type: "MarmitonSelection"})
Selection.create({url: "http://www.marmiton.org/recettes/selection_salade.aspx", description: "Salades", type: "MarmitonSelection"})
Selection.create({url: "http://www.750g.com/touteslesrecettes_encas-168483-1.htm", description:"En cas", type:"SeptSelection"})
Selection.create({url: "http://www.750g.com/touteslesrecettes_sandwich-147260-1.htm", description:"Sandwich", type:"SeptSelection"})

