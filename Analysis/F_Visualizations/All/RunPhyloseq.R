#RunPhyloseq.R

library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")
library("biomformat")

source("new_functions.R")

merged_metagenomes <- new_import_biom("all.biom")

#View(merged_metagenomes@tax_table@.Data)

merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")


#alpha richness calculate
merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")

#alpha richness pdf
pdf(file="alpha.pdf")
plot_richness(physeq = merged_metagenomes, 
             title = "Alpha diversity indexes for Zones and Controls",
             measures = c("Observed","Chao1","Shannon"))             
dev.off()

#Absolute and relative abundances
merged_metagenomes <- subset_taxa(merged_metagenomes, Genus != "") #Only genus that are no blank
percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )

#phyloseq taxa and abund calculate
percentages_glom <- tax_glom(percentages, taxrank = 'Phylum')
percentages_df <- psmelt(percentages_glom)
absolute_glom <- tax_glom(physeq = merged_metagenomes, taxrank = "Phylum")
absolute_df <- psmelt(absolute_glom)       
                                                                                                               
absolute_df$Phylum <- as.factor(absolute_df$Phylum)
phylum_colors_abs<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(absolute_df$Phylum)))
                    
#phyloseq taxa and abund pdf
absolute_plot <- ggplot(data= absolute_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
    geom_bar(aes(), stat="identity", position="stack")+
    scale_fill_manual(values = phylum_colors_abs)+
    theme(legend.text = element_text(size=4), axis.text.x =element_text(angle=90, vjust=0.5, hjust=1))
                                                
percentages_df$Phylum <- as.character(percentages_df$Phylum) # Return the Phylum column to be of type character
#percentages_df$Phylum[percentages_df$Abundance < 0.5] <- "Phyla < 0.5% abund."
         
pdf(file="taxa.pdf")
percentages_df$Phylum <- as.factor(percentages_df$Phylum)
phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = phylum_colors_rel)+
  theme(legend.text = element_text(size=4), axis.text.x =element_text(angle=90, vjust=0.5, hjust=1))
absolute_plot | relative_plot
dev.off()
