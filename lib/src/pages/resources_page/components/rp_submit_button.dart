part of '../resources_page.dart';

class _RPSubmitButton extends StatelessWidget {
  const _RPSubmitButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: k16APadding,
      child: SizedBox(
        width: double.infinity,
        child: ShadButton(
          onPressed: () => launchUrlString(
            'https://github.com/sangddn/prompt_builder/issues/new',
          ),
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
