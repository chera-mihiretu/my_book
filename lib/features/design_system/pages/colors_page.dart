import 'package:flutter/material.dart';
import 'package:new_project/core/theme/app_colors.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System - Colors')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'Brand Colors'),
          _buildColorRow(context, 'Primary', AppColors.primary),
          _buildColorRow(context, 'Primary Light', AppColors.primaryLight),
          _buildColorRow(context, 'Secondary Light', AppColors.secondaryLight),
          _buildColorRow(context, 'Secondary', AppColors.secondary),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Neutral Colors'),
          _buildColorRow(context, 'Background', AppColors.background),
          _buildColorRow(context, 'Surface', AppColors.surface),
          _buildColorRow(context, 'Error', AppColors.error),
          _buildColorRow(context, 'On Primary', AppColors.onPrimary),
          _buildColorRow(context, 'On Secondary', AppColors.onSecondary),
          _buildColorRow(context, 'On Background', AppColors.onBackground),
          _buildColorRow(context, 'On Surface', AppColors.onSurface),
          _buildColorRow(context, 'On Error', AppColors.onError),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Dark Theme Colors'),
          _buildColorRow(context, 'Dark Background', AppColors.darkBackground),
          _buildColorRow(context, 'Dark Surface', AppColors.darkSurface),
          _buildColorRow(
            context,
            'Dark On Background',
            AppColors.darkOnBackground,
          ),
          _buildColorRow(context, 'Dark On Surface', AppColors.darkOnSurface),
          _buildColorRow(context, 'Dark Primary Light', AppColors.primaryLight),
          _buildColorRow(context, 'Dark Primary', AppColors.darkPrimary),
          _buildColorRow(context, 'Dark Secondary', AppColors.darkSecondary),
          _buildColorRow(context, 'Dark On Primary', AppColors.darkOnPrimary),
          _buildColorRow(
            context,
            'Dark On Secondary',
            AppColors.darkOnSecondary,
          ),
          _buildColorRow(context, 'Error Light', AppColors.errorLight),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Semantic Colors'),
          _buildColorRow(context, 'Success', AppColors.success),
          _buildColorRow(context, 'Warning', AppColors.warning),
          _buildColorRow(context, 'Info', AppColors.info),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildColorRow(BuildContext context, String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '#${color.toARGB32().toRadixString(16).toUpperCase().substring(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
